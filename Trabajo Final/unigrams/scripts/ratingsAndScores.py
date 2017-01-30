#!/usr/bin/env python
import glob, os, csv
from ast import literal_eval as make_tuple

with open('filesRatingsScores.csv', 'w') as output:
    results = csv.reader(open('fileScores.csv'), delimiter=',')
    measures = csv.reader(open('../Books/All-TXT/readabilitymeasures.csv'), delimiter=',')
    myDictionary = {}
    
    for entry in measures:
        entry = map(lambda v: v.strip(), entry)
        nameWOExtension = ".".join(entry[0].split(".")[0:-1])
        myDictionary[nameWOExtension] = ','.join(entry[1:])

    for result in results:
        result = map(lambda v: v.strip(), result)
        filename = result[0]
        if filename in myDictionary:
            line = '"'+result[0]+'",' + ",".join(result[1:]) + "," + myDictionary[filename] + "\n"
            output.write(line)
        else:
            print filename
