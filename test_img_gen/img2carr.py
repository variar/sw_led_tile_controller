#!/usr/bin/python
import os, sys
import Image

for infile in sys.argv[1:]:
  f,e = os.path.splitext(infile)
  outfile = f + ".h"
  outscaled = f + "_scaled.png"
  if infile != outfile:
    im = Image.open(infile)
    im = im.convert("RGB")
    width,height = im.size
    im.thumbnail((width, 16), Image.ANTIALIAS)
    im.save(outscaled)
    
    width,height = im.size
    
    of = open(outfile, "w")
    
    of.write("/**\n * Converted from ")
    of.write(infile)
    of.write("\n**/\n")
    
    of.write("#define IMAGE_WIDTH ")
    of.write(str(width))
    of.write("\n")
    
    of.write("#define IMAGE_HEIGHT ")
    of.write(str(height))
    of.write("\n")
    
    of.write("unsigned int image_raw_size = ")
    of.write(str(width*height*3))
    of.write(";\n")
    
    of.write("unsigned char image_raw[] = {\n")
    
    column = 1
    
    for p in im.getdata():
      r,g,b = p
      of.write("0x%0.2x"%r)
      of.write(", ")
      of.write("0x%0.2x"%g)
      of.write(", ")
      of.write("0x%0.2x"%b)
      of.write(",")
      
      if column != 16:  
	of.write(" ")
	column=column+1
      else:
        column = 0
        of.write("\n")
      
    of.seek(-2, 1)
    
    of.write("\n};\n")
    of.close()
    
    
    
