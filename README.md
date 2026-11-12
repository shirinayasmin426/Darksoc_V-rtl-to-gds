# DarkSoCV – RTL-to-GDS on Sky130 and GPDK045

Physical implementation of the **DarkSoCV** RISC-V SoC on two process design kits, from floorplan to signoff.
Several implementation styles were run so their results can be compared.

| # | Variant | PDK | Supply | Notes |
|---|---------|-----|--------|-------|
| 1 | DarkSoCV, **flat** | SkyWater sky130 | 1.8 V | Whole design in one pass; long run times |
| 2 | DarkSoCV, **hierarchical** | sky130 | 1.8 V | RAM (`darkram`) implemented separately, reused as block `bram0` |
| 3 | `darkram` (standalone) | sky130 | 1.8 V | RAM module of DarkSoCV, L-shaped core |
| 4 | DarkSoCV, 70% initial utilization | GPDK045 (45 nm) | 0.9 V | Flat |
| 5 | DarkSoCV, 55% initial utilization | GPDK045 (45 nm) | 0.9 V | Flat |

## Tools

| Step | Tool |
|------|------|
| Floorplan, place, CTS, route, ECO | Cadence Innovus 22.18 |
| Static timing signoff | Cadence Tempus 23.14 |
| Static IR drop | Cadence Voltus 23.14 |
| DRC and LVS | Cadence Pegasus 22.13 |

PDK paths used in the runs: `/pdk/sky130_release_0.1.0` (LVS deck `Sky130_LVS/sky130.lvs.v0.0_1.1.pvl`) and `/pdk/gpdk045/gpdk045_v_6_0` (LVS deck `pvs/pv1LVS.rul`).

## Implementation procedure

The same stage sequence is used for every variant. Command lines below are the usual Innovus sequence; adapt option names to your own scripts and PDK setup files.

### 1. Setup and floorplan
1. Read the netlist, LEF, liberty (MMMC views) and constraints (`init_design`).
2. Create the floorplan at the target utilization (`floorPlan ...`). Save as `fp2.inn.dat` after pin placement.
3. Connect power nets (`globalNetConnect`), add rings and a mesh of vertical and horizontal stripes (`addRing`, `addStripe`), then route the standard-cell rails (`sroute`).

### 2. Placement and pre-CTS
1. Place the design (`place_design`), save `place.inn.dat`, and check congestion.
2. Optimise before CTS (`optDesign -preCTS`).
3. Report timing: `timeDesign -preCTS -outDir report/prects/preCTSOptTiming`.

### 3. Clock tree synthesis
1. Build the clock tree (`create_ccopt_clock_tree_spec`, `ccopt_design`), save `cts.inn.dat`.
2. Inspect the tree in the Clock Tree Debugger.
3. Optimise after CTS (`optDesign -postCTS`) and report: `timeDesign -postCTS -outDir report/postcts/ctsTimingReports`.

### 4. Routing
1. Route (`routeDesign`) and optimise (`optDesign -postRoute`).
2. Report: `timeDesign -postRoute -outDir report/route/routeTimingReports`.
3. Check DRVs, density and process antenna violations in the Violation Browser. Save `route_drc.inn.dat`.

### 5. Signoff
1. **STA (Tempus):** run multi-view analysis, apply ECO fixes for setup and hold, and write the category summaries before and after fixes:
   `write_category_summary -report category_before_early.rpt` (and `_late`, `category_after_*`).
2. **IR drop (Voltus):** run static rail analysis and review the Result Browser distribution.
3. **DRC and LVS (Pegasus):** stream out GDS, then run DRC and LVS with the PDK rule decks.
4. **Antenna:** review NanoRoute process-antenna violations. Fix by inserting antenna diodes (for example `setNanoRouteMode -routeInsertAntennaDiode true -routeAntennaCellName <diode cell>`), then re-route and re-verify.

### Hierarchical flow (variants 2 and 3)
The flat run took too long, so the RAM was split out:
1. Implement `darkram` on its own through steps 1–5 (variant 3).
2. Use the signed-off `darkram` as a pre-implemented block, named `bram0`, in the DarkSoCV top-level floorplan.
3. Place and route only the glue logic around the fixed block (variant 2).

## Results

Slack values are in ns. "Post-route" means `timeDesign -postRoute`.

### Sky130

| Item | Flat | Hierarchical top | `darkram` |
|------|------|------------------|-----------|
| Pre-CTS WNS | -0.170 (29 paths) | +0.094 | +0.021 |
| Post-CTS WNS | – | +0.099 | +0.059 |
| Post-route WNS | +0.066 | +0.077 | -0.013 (1 path) |
| Post-route density | 56.3% | 54.6% | 35.4% |
| Post-route DRVs | 0 | 0 | 11 nets max_tran |
| Tempus (typical) after fixes | 0 failing | 0 failing | 0 failing |
| Static IR drop | worst bin > 3.6 mV (VDD) | not reported | not reported |
| Antenna violations | 1,388 | not reported | 502 |
| DRC | 5,009 results / 13 rules (PDK) | 6,030 results / 16 rules (PDK) | 2,026 results / 10 rules (PDK) |
| LVS | clean | not reported | clean |

Flat run, Tempus `func_typical_0_1v8`: before fixes 429 failing late paths (WNS -0.911, TNS about -170), after fixes 0.
`darkram` Tempus `func_typical_0_1v2`: before fixes 31,284 failing early (hold) paths (WNS -1.694), after fixes 0.

### GPDK045 (flat, VDD = 0.9 V)

| Item | 70% initial utilization | 55% initial utilization |
|------|--------------------------|--------------------------|
| Placement density | 71.4% | 55.7% |
| Pre-CTS WNS | +0.102 | +0.094 |
| Post-route WNS | +0.076 | +0.077 |
| Post-route density | 69.8% | 54.6% |
| Post-route DRVs | 8 nets max_tran (worst -0.013) | 0 |
| Tempus before fixes (slow corner) | early 1 path; late 78 paths (WNS -0.052) | early 1 path; late 32 paths (WNS -0.034) |
| Tempus after fixes | 0 failing | 0 failing |
| Static IR drop (VDD) | not reported | max 24.03 mV (about 2.7% of 0.9 V) |
| Antenna violations | 0 | 0 |
| DRC | 1,013 results / 4 rules (PDK) | 1,022 results / 4 rules (PDK) |
| LVS | 334 soft-check results (PDK) | 370 soft-check results (PDK) |

Both utilizations close timing with almost the same post-route WNS. The 70% run is about 15 points denser (smaller core) but needs more fixes before closure and ends with max_tran violations.

## Sky130 vs GPDK045

- **Antenna:** GPDK045 shows no antenna violations. Sky130 shows many (1,388 on the flat run, mostly on met4), which antenna diodes can fix.
- **DRC and LVS:** both PDKs report results from PDK soft checks (`soft_check_*`, `LVS_SOFTCHK`, and well, implant, fill and density-window rules on sky130). These are outside the PnR flow and are left as known PDK issues.
- **Supply:** 1.8 V on sky130, 0.9 V on GPDK045, so IR-drop budgets differ.
- **Corners:** views used are `func_slow_125_1v0`, `func_typical_0_1v8` (or `_1v2`) and `func_fast_0_1v2`.

## Known issues and items to verify

- **Sky130 hierarchical top:** the stage-timing reports (pre-place, pre-CTS, post-CTS, post-route) had the same timestamps and values as the GPDK045 55% run. Confirm they belong to the hierarchical run before publishing.
- **`darkram` post-route:** WNS -0.013 ns on 1 path and 11 max_tran nets, plus 502 antenna violations, are still open.
- **Slow-corner RC setup:** a slow-corner late report for `darkram` showed all paths failing (WNS -3.800 ns). If this recurs, check the RC corner (`rcworst_slow`) and QRC tech file, and confirm Tempus uses the same parasitics as Innovus.
- **IR drop on sky130 hierarchical runs:** an earlier VDD result had a top bin near 572 mV on a 1.8 V supply, which needs checking (power connection or analysis setup).
- **Corner coverage:** several reports and slides list only the typical corner. Add slow and fast results if full multi-corner signoff is needed.
```

## Acknowledgements

DarkSoCV is an open-source RISC-V SoC. Sky130 is the SkyWater open PDK; GPDK045 is Cadence's generic 45 nm PDK.
