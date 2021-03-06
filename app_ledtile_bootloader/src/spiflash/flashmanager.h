// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/**
 * Module:  LedRefDesign_Bootloader
 * Version: 9.10.0
 * Build:   4061a1a31070a4a2edc04cae089d434475f9cb06
 * File:    flashmanager.h
 *
 *
 **/                                   
#ifndef SPIFLASH_H_
#define SPIFLASH_H_

#ifdef __XC__  // required for 9.9.2 tools
#include <platform.h>
#endif

#define SPI_FLASH_READ          0
#define SPI_FLASH_WRITEFIRMWARE 1
#define SPI_FLASH_NEWFIRMWARE   2
#define SPI_FLASH_NEWGAMMA      3
#define SPI_FLASH_READGAMMA     4

#ifdef __XC__
void spiFlash(chanend cSpiFlash,
    buffered in port:8 p_flash_miso, out port p_flash_ss, buffered out port:32 p_flash_clk, buffered out port:8 p_flash_mosi, clock b_flash_clk, clock b_flash_data);
#endif

#endif /*SPIFLASH_H_*/
