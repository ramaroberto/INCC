#!/usr/bin/python
import re
import sys
import os.path
import operator

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

books = []
is_book = False
cache = ""
for line in file_in:
    cache += line
    if line.lstrip().rstrip() == "group: Book":
        is_book = True
    if line.lstrip().rstrip() == '' and is_book:
        have_cat = re.search("\|"+category+"\[", cache) is not None
        
        if have_cat:
            title = re.search("title: ([\w\d \:]*)", cache).group(1)
            salesrank = re.search("salesrank: (\d*)", cache).group(1)
            reviews = re.search("reviews: total: (\d*)  downloaded: (\d*)  avg rating: (\d*\.?\d*)", cache)
            quantity = int(reviews.group(1))
            score = float(reviews.group(3))
            
            books.append((quantity, score, title))
    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False
    
# Sort them
sorted_books = sorted(books, key=operator.itemgetter(0), reverse=True)

print " \n(Cantidad de reviews, Score, Titulo)"
for book in sorted_books:
    if book[0] > 10:
        print book
print