#!/usr/bin/python
#!python

import re
import os

for i in range(1,15):
	os.system("sed 's/\"//g' r"+str(i)+".csv > r"+str(i)+"bis.csv")
	os.system("sed 's/;/,/g' r"+str(i)+"bis.csv > ../parsed_data/r"+str(i)+".csv")
	os.system("rm r"+str(i)+"bis.csv")
	
	f = open("../parsed_data/r"+str(i)+".csv","r")
	f.readline()
	fstr = f.read()
	f.close()
	
	# Regular expressions
	result = re.sub(r"(,[a-zA-Z]*),", ",", fstr)

	f = open("../parsed_data/r"+str(i)+".csv","w")
	f.write(result)
	f.close()
	
for i in range(1,17):
	os.system("sed 's/\"//g' s"+str(i)+".csv > s"+str(i)+"bis.csv")
	os.system("sed 's/;/,/g' s"+str(i)+"bis.csv > ../parsed_data/s"+str(i)+".csv")
	os.system("rm s"+str(i)+"bis.csv")
	
	f = open("../parsed_data/s"+str(i)+".csv","r")
	f.readline()
	fstr = f.read()
	f.close()
	
	# Regular expressions
	result = re.sub(r"(,[a-zA-Z]*),", ",", fstr)

	f = open("../parsed_data/s"+str(i)+".csv","w")
	f.write(result)
	f.close()	
