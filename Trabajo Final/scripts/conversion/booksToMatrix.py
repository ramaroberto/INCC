#!/usr/bin/python
import re
import sys
import os.path
import operator
import math

# If not enough parameters are provided
if len(sys.argv) < 2:
    print "[Error] Ingrese el nombre del archivo."
    quit()

source_fn = sys.argv[1]

# Check for existence
if not os.path.exists(source_fn) or  not os.path.isfile(source_fn):
    print "[Error] Source file doesn't exist."
    quit()
file_in = open(source_fn, 'r')

if len(sys.argv) < 3:
    print "[Error] Ingrese la categoria a filtrar."
    quit()
category = sys.argv[2]

m = [[0 for j in range(10)] for i in range(8)]

is_book = False
cache = ""
for line in file_in:
    cache += line
    if line.lstrip().rstrip() == "group: Book":
        is_book = True
    if line.lstrip().rstrip() == '' and (is_book):
        have_cat = re.search("\|"+category+"\[", cache) is not None
        reviews = re.search("reviews: total: (\d*)  downloaded: (\d*)  avg rating: (\d*\.?\d*)", cache)
        quantity = int(reviews.group(1))
        score = float(reviews.group(3))

        if (have_cat or category == 'ALL') and quantity > 0:
            si = int((score - 1.5)*2)
            qi = int(min([math.floor(float(quantity)/100),9]))
            m[si][qi] += 1

    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False

print m
