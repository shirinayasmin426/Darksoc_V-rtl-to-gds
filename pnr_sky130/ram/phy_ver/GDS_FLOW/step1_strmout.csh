#!/bin/csh -vf

strmout \
 -library 	 MYLIBRARY \
 -strmFile  	 darkram.gds.gz \
 -topCell        darkram \
 -view           layout \
 -logFile        strmout.log \
 -techLib        sky130_fd_pr_main	\
 -hierDepth      32	\
 -layerMap       ./sky130_fd_pr_main.layermap     \
 -labelDepth     32	\
 -case           Preserve 
  
