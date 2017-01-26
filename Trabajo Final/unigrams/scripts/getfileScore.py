#!/usr/bin/env python
import glob, os, csv
from ast import literal_eval as make_tuple

with open('fileScores.csv', 'wb') as file:
	# filewriter = txt.writer(csvfile, quoting=csv.QUOTE_MINIMAL)
	amazonDB = open('../Books/all-downloaded-books.txt','r')
	booksAndRating = []
	for line in amazonDB:
		lineTuple = make_tuple(line)
		bookInList = ''.join(c.lower() for c in lineTuple[2] if c.isalnum() or c.isspace()).split()
		booksAndRating.append(tuple((lineTuple[1],lineTuple[3],bookInList)))


	allNames = [os.path.splitext(f)[0] for f in os.listdir("../Books/All-TXT/") if f.endswith('.txt')]
	# para probar con pocos ejemplos: allNames = [os.path.splitext(f)[0] for f in os.listdir("prueba/") if f.endswith('.txt')]
	for f in allNames:
		words = ''.join(c for c in f if c.isalnum() or c.isspace()).split()
		wordCounter = 0
		maxCounter = 0
		rating = 0.0
		id = 0
		print words
		for bookEntry in booksAndRating:
			wordCounter = 0
			for x in words:
				if x.lower() in bookEntry[2]:
					wordCounter+=1
			if wordCounter>maxCounter:
				maxCounter = wordCounter
				rating = bookEntry[0]
				id = bookEntry[1]
				entry = bookEntry[2]
		print str(entry) + '\n'
		file.write(f+', '+str(rating)+', '+str(id)+'\n')
