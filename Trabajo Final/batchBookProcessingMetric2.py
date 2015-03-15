#!/usr/bin/python

#from __future__ import print_function
import re
import sys
import os
import operator

# If not enough parameters are provided
if len(sys.argv) < 2:
    print "[Error] Ingrese el directorio sobre el cual iterar."
    quit()

directory = sys.argv[1]
if directory[-1] != '/':
	directory += directory + '/'

# Check for existence
if not os.path.exists(directory) or  not os.path.isdir(directory):
    print "[Error] El directorio indicado no existe."
    quit()

for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith('.txt'):
        	print file
        	#print "./scriptForBooks.py " + re.escape(directory) + re.escape(file)
        	#os.system("./scriptForBooks.py " + "Books\ For\ Experimenting/Contemporary/TXT/Positivos/A\ Fine\ Balance\ -\ Rohinton\ Mistry.txt")
        	os.system("./scriptForBooksMetric2.py " + re.escape(directory) + re.escape(file))
        	print