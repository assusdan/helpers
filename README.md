# HELPERS

### ```My scripts. Developed to make kernel and android development easier```

``` How to Use ```

> ### For Parsing DTS From Stock DTB :
                                dts.sh markw Image.gz-dtb
				markw = my device name here
			        Image.gz-dtb = my kernel name in this directory!

> ### For comparing Defconfigs :
                                 python compare_defconfig.py mido_defconfig mido1_defconfig > Difference.txt
				 mido_defconfig & mido1_defconfig = name of defconfig to compare!
				 Difference.txt = Difference between two defconfig!

> ###_For Repacking ( boot.img & recovery.img ) : 
                                 python repack_images.py stock.img folderwithkernels/


```contributors ```

* @assusdan
* @yuvraj99
