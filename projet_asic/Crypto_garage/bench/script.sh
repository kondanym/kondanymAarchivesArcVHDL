#!/bin/bash

## nettoyage
if [ -d ../libs/LIB_CGARAGE_BENCH ] 
then /bin/rm -rf ../libs/LIB_CGARAGE_BENCH
fi

## creation de la librairie de travail
vlib ../libs/LIB_CGARAGE_BENCH


## compilation
vcom -work LIB_CGARAGE_BENCH test.vhd

