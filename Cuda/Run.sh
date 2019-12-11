#!/bin/bash

if [ -f "./a.out" ]; then
  "./a.out" 100;
else
  echo -e "\nERROR: You must compile before running program!\n";
fi
