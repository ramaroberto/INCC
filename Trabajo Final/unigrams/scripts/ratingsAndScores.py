#!/usr/bin/env python
import glob, os, csv
from ast import literal_eval as make_tuple

with open('filesRatingsScores.csv', 'wb') as file:
	results = open('fileScores.csv','r')	
	measures = open('../Books/All-TXT/readabilitymeasures.csv','r')
	myDictionary = {}
	for entry in measures:
		entryMeasure = entry.split(",")
		nameWOExtension = entryMeasure[0].split(".")[0]
		myDictionary[nameWOExtension] = ','.join(entryMeasure[1:])
	for line in results:
		lineName = line.split(",")
		filename = lineName[0]
		if filename in myDictionary:
			file.write(line.replace('\n', ' ') +',' + myDictionary[filename])
		