# Usage: 
# python compare_defconfig.py defconfigA defconfigB > difference.txt
# 
# Compare two defconfigs and add difference in file

import sys

a = open(sys.argv[1])
b = open(sys.argv[2])

lista = []
listb = []

for line in a:
  if line.__len__()>3:
    if line[-1]!='\n': line+='\n'
    if line[0]!='#':
      lista.append(line[:-1].split('='))

for line in b:
  if line.__len__()>3:
    if line[-1]!='\n': line+='\n'
    if line[0]!='#':
      listb.append(line[:-1].split('='))

listd1 = [line for line in lista if line not in listb]
listd2 = [line for line in listb if line not in lista]

print ("ONLY IN FIRST: ")
for line in listd1:
  print(line)

print()

print ("ONLY IN SECOND: ")
for line in listd2:
  print(line)
