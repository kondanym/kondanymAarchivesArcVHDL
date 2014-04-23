#!/bin/bash

# source ../confmodelsim/config 

## nettoyage
if [ -d ../libs/LIB_CGARAGE ] 
then /bin/rm -rf ../libs/LIB_CGARAGE 
fi

## creation de la librairie de travail
vlib ../libs/LIB_CGARAGE

## compilation
vcom -work LIB_CGARAGE binary.vhdl
