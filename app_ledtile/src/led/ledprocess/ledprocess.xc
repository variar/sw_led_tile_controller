// Copyright (c) 2011, XMOS Ltd., All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/**
 * Module:  LedRefDesign
 * Version: 10.4.1
 * Build:   977cb8e0d3fefc67ac350c5f294ac65919b3ebdc
 * File:    ledprocess.xc
 *
 *
 **/                                   
#include <xs1.h>
#include <xclib.h>
#include "led.h"
#include "ledprocess.h"
#include "print.h"

//8 bit color intensity adjustements
unsigned char intensityadjust[3] = {0xFF, 0xFF, 0xFF};
//16 bit gamma look up table
unsigned short gammaLUT[3][256] =
{
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 35, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 93, 94, 95, 97, 98, 99, 100, 102, 103, 105, 106, 107, 109, 110, 111, 113, 114, 116, 117, 119, 120, 121, 123, 124, 126, 127, 129, 130, 132, 134, 135, 137, 138, 140, 141, 143, 145, 146, 148, 149, 151, 153, 154, 156, 158, 159, 161, 163, 165, 166, 168, 170, 172, 173, 175, 177, 179, 181, 182, 184, 186, 188, 190, 192, 194, 196, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 234, 236, 238, 240, 242, 244, 246, 248, 251, 253, 255},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 35, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 93, 94, 95, 97, 98, 99, 100, 102, 103, 105, 106, 107, 109, 110, 111, 113, 114, 116, 117, 119, 120, 121, 123, 124, 126, 127, 129, 130, 132, 134, 135, 137, 138, 140, 141, 143, 145, 146, 148, 149, 151, 153, 154, 156, 158, 159, 161, 163, 165, 166, 168, 170, 172, 173, 175, 177, 179, 181, 182, 184, 186, 188, 190, 192, 194, 196, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 234, 236, 238, 240, 242, 244, 246, 248, 251, 253, 255},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 18, 18, 19, 19, 20, 20, 21, 22, 22, 23, 23, 24, 25, 25, 26, 26, 27, 28, 28, 29, 30, 30, 31, 32, 33, 33, 34, 35, 35, 36, 37, 38, 39, 39, 40, 41, 42, 43, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 73, 74, 75, 76, 77, 78, 79, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 93, 94, 95, 97, 98, 99, 100, 102, 103, 105, 106, 107, 109, 110, 111, 113, 114, 116, 117, 119, 120, 121, 123, 124, 126, 127, 129, 130, 132, 134, 135, 137, 138, 140, 141, 143, 145, 146, 148, 149, 151, 153, 154, 156, 158, 159, 161, 163, 165, 166, 168, 170, 172, 173, 175, 177, 179, 181, 182, 184, 186, 188, 190, 192, 194, 196, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 234, 236, 238, 240, 242, 244, 246, 248, 251, 253, 255}
};

#pragma unsafe arrays
void ledprocess_init()
{
  // Init pixintensity
#ifdef PER_PIXEL_ADJUSTMENT
  for (int i=0; i<(FRAME_HEIGHT*FRAME_WIDTH*3); i++)
  {
    (pixintensity, unsigned char[])[i] = -1;
  }
#endif
}


// ledreprocess
// Load pixel data from buffer and apply gamma LUT and intensity colour correction
#pragma unsafe arrays
int ledprocess_commands(streaming chanend cLedCmd, streaming chanend cOut, int outen)
{
  int ledCmdResponse;
  
  // Check for commands
  cLedCmd <: 0;
  cLedCmd :> ledCmdResponse;
  while (ledCmdResponse == 0)
  {
    // New command received
    unsigned int cmdlen, cmdtyp;
    cLedCmd :> cmdlen;
    cLedCmd :> cmdtyp;
    switch (cmdtyp)
    {
      case (XMOS_GAMMAADJ):
      {
        int colchan;
        
        cLedCmd :> colchan;

        cmdlen -= 2;
        if (cmdlen > 256) {
          cmdlen = 256;
        }
        for (int i=0; i < cmdlen; i++)
        {
          int data;
          cLedCmd :> data;
          
          switch(colchan)
          {
            case ('R'):              
              gammaLUT[0][i] = (unsigned short)data;
              break;
            case ('G'):
              gammaLUT[1][i] = (unsigned short)data;
              break;
            case ('B'):
              gammaLUT[2][i] = (unsigned short)data;
              break;
            default:
              gammaLUT[0][i] = (unsigned short)data;
              gammaLUT[1][i] = (unsigned short)data;
              gammaLUT[2][i] = (unsigned short)data;
              break;
          }
        }
      }
      break;
      case (XMOS_CHANGEDRIVER):
      {
        int newdrivertype;
        cLedCmd :> newdrivertype;
        if (outen)
        {
          cOut <: 0;
          cOut <: XMOS_CHANGEDRIVER;
          cOut <: newdrivertype;
        }
        return (newdrivertype);
      }
      break;
      case (XMOS_INTENSITYADJ):
      {
        int colchan, data;
        
        cLedCmd :> colchan;
        cLedCmd :> data;
        
        if (outen)
        {
          cOut <: 0;
          cOut <: XMOS_INTENSITYADJ;
          switch(colchan)
          {
            case ('R'):
              cOut <: 0x09090909;
              break;
            case ('G'):
              cOut <: 0x12121212;
              break;
            case ('B'):
              cOut <: 0x24242424;
              break;
            default:
              cOut <: 0xFFFFFFFF;
              break;
          }
          cOut <: data;
        }
      }
      break;
      case (XMOS_SINTENSITYADJ):
      {
        int colchan, data;
        
        cLedCmd :> colchan;
        cLedCmd :> data;
        
        switch(colchan)
        {
          case ('R'):
            intensityadjust[0] = data;
            break;
          case ('G'):
            intensityadjust[1] = data;
            break;
          case ('B'):
            intensityadjust[2] = data;
            break;
          default:
            intensityadjust[0] = data;
            intensityadjust[1] = data;
            intensityadjust[2] = data;
            break;
        }
      }
      break;
      case (XMOS_SINTENSITYADJ_PIX):
#ifdef PER_PIXEL_ADJUSTMENT
      {
        int colchan, x, y, data;
        
        cLedCmd :> colchan;
        cLedCmd :> y;
        cLedCmd :> x;
        cLedCmd :> data;
        switch(colchan)
        {
          case ('R'):
            pixintensity[y][x][0] = data;
            break;
          case ('G'):
            pixintensity[y][x][1] = data;
            break;
          case ('B'):
            pixintensity[y][x][2] = data;
            break;
          default:
            pixintensity[y][x][0] = data;
            pixintensity[y][x][1] = data;
            pixintensity[y][x][2] = data;
            break;
        }
      }
#endif
      break;
      default:
        for (int i=1; i < cmdlen; i++)
          cLedCmd :> int;
        break;
    }
    cLedCmd <: 0;
    cLedCmd :> ledCmdResponse;
  }
  
  if (outen)
  {
    cOut <: 1;
  }
  return 0;
}
