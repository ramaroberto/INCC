#!/usr/bin/python
import re
import sys
import os.path
import operator

# Constants
qlimit = 50

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

c1 = ["Science_Fiction_And_Fantasy", "Classics", "Fantasy", "Science_Fiction", "World_Literature"]
c2 = ["Religion_And_Spirituality", "Fiction", "Health_Mind_And_Body", "Self-Help"]
c3 = ["Mystery_And_Thrillers", "Thrillers", "Biographies_And_Memoirs", "Suspense", "Nonfiction", "History", "Politics", "Social_Sciences"]
c4 = ["CATCH_ALL"]
clusters = [c1,c2,c3,c4]

cluster = []
nc = int(category[7:8])-1
cluster_classification = (category[0:7] == 'CLUSTER')
if cluster_classification:
    if clusters[nc][0] == "CATCH_ALL":
        for i in range(len(clusters)):
            if i != nc:
                cluster += clusters[i]
    else:
        cluster = clusters[nc]

books = []
is_book = False
cache = ""
for line in file_in:
    cache += line
    if line.lstrip().rstrip() == "group: Book":
        is_book = True
    if line.lstrip().rstrip() == '' and (is_book):
        have_cat = re.search("\|"+category+"\[", cache) is not None
        
        if cluster_classification:
            have_cat = False
            book_categories = re.findall("\|([\w \&\,\-]*)\[\d*\]", cache)
            for book_category in book_categories:
                book_category = book_category.replace(" ", "_").replace("&", "And").replace(",", "")
                if book_category in cluster:
                    have_cat = True
                    break
            if clusters[nc][0] == "CATCH_ALL":
                have_cat = not have_cat

        if have_cat or category == 'ALL':
            title = re.search("title: ([\w\-\,\&\' \.\:\(\)\#]*)", cache).group(1)
            code = re.search("ASIN: (\d*)", cache).group(1)
            salesrank = re.search("salesrank: (\d*)", cache).group(1)
            reviews = re.search("reviews: total: (\d*)  downloaded: (\d*)  avg rating: (\d*\.?\d*)", cache)
            quantity = int(reviews.group(1))
            score = float(reviews.group(3))
            
            if quantity >= qlimit:
                books.append((quantity, score, title, code))
    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False
    
# Sort them
sorted_books = sorted(books, key=operator.itemgetter(1,0), reverse=True)

print " \n(Cantidad de reviews, Score, Titulo)"
for book in sorted_books:
    if book[0] > 10:
        print book
print