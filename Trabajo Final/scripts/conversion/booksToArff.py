#!/usr/bin/python
import re
import sys
import os.path
import operator

# Constants
qlimit = 50
catlimit = 200

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

if len(sys.argv) < 4:
    print "[Error] Ingrese el nombre del archivo de salida."
    quit()
target_fn = sys.argv[3]

print "Collecting the categories..."

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
        if (have_cat or category == 'ALL') and quantity >= qlimit:
            book_categories = re.findall("\|([\w \&\,\-]*)\[\d*\]", cache)
            for book_category in book_categories:
                if book_category in categories:
                    categories[book_category] += 1
                else:
                    categories[book_category] = 1

    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False
file_in.close()

categories_items = categories.items()

# Sort them
sorted_categories = sorted(categories_items, key=operator.itemgetter(1,0), reverse=True)

# Inicializamos variables para la generacion del arff
file_in = open(source_fn, 'r')
file_out = open(target_fn, 'w')
catindex = {}
disc = 0

# Escribimos headers
file_out.write("@relation BooksCategories\n\n")
#file_out.write("@attribute Title string\n")
file_out.write("@attribute Code numeric\n")
file_out.write("@attribute Rank numeric\n")
file_out.write("@attribute Score {0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5}\n")
file_out.write("@attribute Quantity numeric\n")
for i in range(len(sorted_categories)):
    cat_name = sorted_categories[i][0].replace(" ", "_").replace("&", "And").replace(",", "")
    cat_quantity = sorted_categories[i][1]
    if (cat_name == "") or (cat_name in catindex):
        disc += 1
        continue
    if cat_quantity < catlimit:
        break
    catindex[cat_name] = i - disc
    file_out.write("@attribute Cat_" + cat_name + " {0,1}\n")
    #print (i - disc), sorted_categories[i][0], sorted_categories[i][1]
file_out.write("@data\n\n")

print "Generating ARFF from " + str(len(catindex.items())) + " categories..."

# Escribimos datos
for line in file_in:
    cache += line
    if line.lstrip().rstrip() == "group: Book":
        is_book = True
    if line.lstrip().rstrip() == '' and (is_book):
        have_cat = re.search("\|"+category+"\[", cache) is not None
        reviews = re.search("reviews: total: (\d*)  downloaded: (\d*)  avg rating: (\d*\.?\d*)", cache)
        quantity = int(reviews.group(1))
        if (have_cat or category == 'ALL') and quantity >= qlimit:
            title = re.search("title: ([\w\d \:]*)", cache).group(1)
            code = re.search("ASIN: (\d*)", cache).group(1)
            salesrank = re.search("salesrank: (\d*)", cache).group(1)
            quantity = reviews.group(1)
            score = reviews.group(3)

            if code == "":
                code = "0"
            if salesrank == "":
                salesrank = "0"

            cat_vector = [0 for k in range(len(catindex.items()))]

            book_categories = re.findall("\|([\w \&\,\-]*)\[\d*\]", cache)
            for book_category in book_categories:
                book_category = book_category.replace(" ", "_").replace("&", "And").replace(",", "")
                if book_category in catindex:
                    cat_vector[catindex[book_category]] = 1

            # Print the data
            #file_out.write("\"" + title + "\"," + code + "," + score + "," + quantity)
            file_out.write(code + "," + salesrank + "," + score + "," + quantity)
            for catbool in cat_vector:
                file_out.write("," + str(catbool))
            file_out.write("\n")

    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False

file_in.close()
file_out.close()

print "Done!"
