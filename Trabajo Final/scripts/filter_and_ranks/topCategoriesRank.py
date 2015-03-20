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

is_book = False
cache = ""
categories = {}
for line in file_in:
    cache += line
    if line.lstrip().rstrip() == "group: Book":
        is_book = True
    if line.lstrip().rstrip() == '' and (is_book):
        have_cat = re.search("\|"+category+"\[", cache) is not None
        reviews = re.search("reviews: total: (\d*)  downloaded: (\d*)  avg rating: (\d*\.?\d*)", cache)
        quantity = int(reviews.group(1))
        if (have_cat or category == 'ALL') and quantity >= 100:
            book_categories = re.findall("\|([\w \&\,\-]*)\[\d*\]", cache)
            for book_category in book_categories:
                if book_category in categories:
                    categories[book_category] += 1
                else:
                    categories[book_category] = 1
        
    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False

categories_items = categories.items()

# Sort them
sorted_categories = sorted(categories_items, key=operator.itemgetter(1,0), reverse=True)

print " \n(Nombre de la categoria, Cantidad de apariciones)"
for category in sorted_categories:
    print category
    if category[1] < 250:
        break
print