# Usage: 
# python repack_images.py stock.img folderwithkernels/
#
# Repacks your boot/recovery image with all kernels from folderwithkernels/ dir.
# Uses tool.exe for repacking

import sys
from shutil import copyfile
import os
from os import listdir
from os.path import isfile, join

stockboot = sys.argv[1]
kernels = sys.argv[2]

os.system("wine tool "+stockboot)
bootdir = stockboot[:-4]+'_/'

images = [f for f in listdir(kernels) if isfile(join(kernels, f))]

for zimage in images:
	zimage = zimage.split('/')[0]
	copyfile(kernels+zimage, bootdir+'kernel/zImage')
	os.system("wine tool "+bootdir)
	copyfile('new_'+bootdir[:-2]+'.img', zimage+'.img')
