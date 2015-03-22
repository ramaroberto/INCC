#!/usr/bin/python
import re
import sys
import os.path
import operator


# Constants
qlimit = 50
catlimit = 200
show_classification = True

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

titles_to_classify = []
file_class = None
if len(sys.argv) >= 4:
    print "Loading file with titles to find classification."
    books_content = open(sys.argv[3], 'r').read()
    books = re.findall("^\(([\d]*), ([\d\.]*), '([\w\-\,\&\' \.\:\(\)\#]*)', '([\d\.]*)'\).*$", books_content, re.M)
    for book in books:
        titles_to_classify.append(book[2])
    file_class = open((sys.argv[3].split('.'))[0]+"-class.txt", 'w')

c1 = ["Science_Fiction_And_Fantasy", "Classics", "Fantasy", "Science_Fiction", "World_Literature"]
c2 = ["Religion_And_Spirituality", "Fiction", "Health_Mind_And_Body", "Self-Help"]
c3 = ["Mystery_And_Thrillers", "Thrillers", "Biographies_And_Memoirs", "Suspense", "Nonfiction", "History", "Politics", "Social_Sciences"]
#c4 = ["Biographies_And_Memoirs", "Nonfiction", "History", "Politics", "Social_Sciences"]
c4 = ["CATCH_ALL"]
clusters = [c1,c2,c3,c4]
#clusters = [["United_States", "Nonfiction", "History"], ["Biographies_And_Memoirs", "World_Literature"], ["Contemporary"]]

results = [[0,0] for i in range(len(clusters))]

print "Computing the score, reading books...",

is_book = False
cache = ""
count = 0
total = 0
ttc_categories = {}
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
            title = re.search("title: ([\w\-\,\&\' \.\:\(\)\#]*)", cache).group(1)

            for ttc in titles_to_classify:
                if title.startswith(ttc):
                    if ttc in ttc_categories:
                        ttc_categories[ttc] += book_categories
                    else:
                        ttc_categories[ttc] = book_categories
                    break

            in_cluster = [0 for i in range(len(clusters))]
            for book_category in book_categories:
                book_category = book_category.replace(" ", "_").replace("&", "And").replace(",", "")
                for i in range(len(clusters)):
                    for j in range(len(clusters[i])):
                        if clusters[i][j] == "CATCH_ALL":
                            continue
                        if clusters[i][j] == book_category:
                            in_cluster[i] = 1

            addition = reduce(operator.add, in_cluster, 0)
            total += 1

            if addition == 0:
                addition = 1
                for i in range(len(clusters)):
                    for j in range(len(clusters[i])):
                        if clusters[i][j] == "CATCH_ALL":
                            in_cluster[i] = 1

            if total % 100 == 0:
                print total,
                sys.stdout.flush()

            if addition > 0:
                count += 1
                for i in range(len(in_cluster)):
                    if in_cluster[i]:
                        results[i][0] += in_cluster[i]
                        results[i][1] += addition - in_cluster[i]

    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False
file_in.close()

print "Done!"
print

print "--- Title classification ---"
# Compute clasification
ttc_clasification = []
ttc_cluster_count = [0 for i in range(len(clusters))]
for ttc in titles_to_classify:
    if ttc in ttc_categories:
        classes = []
        nclusters = []
        categories = ttc_categories[ttc]
        for i in range(len(clusters)):
            for j in range(len(clusters[i])):
                found = False
                for category in categories:
                    scategory = category.replace(" ", "_").replace("&", "And").replace(",", "")
                    if (scategory == clusters[i][j]) or (clusters[i][j] == "CATCH_ALL" and len(classes) == 0):
                        classes.append(clusters[i][j])
                        nclusters.append(i+1)
                        found = True
                        ttc_cluster_count[i] += 1
                        break
                if found:
                    break
        ttc_clasification.append((ttc, classes, nclusters))
    else:
        ttc_clasification.append((ttc, None, []))

# Print clasification and balancing
ttc_cluster_bcount = ttc_cluster_count[:]
for classified_title in ttc_clasification:
    if classified_title[1] is not None:
        if show_classification:
            print classified_title[0], classified_title[1], classified_title[2],
        idclusters = classified_title[2]

        if len(idclusters) > 1: # Balancing needs to be done
            imin = -1
            # Recorro los id en idclusters
            for i in  range(len(idclusters)):
                # Para cada id, me fijo si es el minimo en bcount
                if (imin == -1) or (ttc_cluster_bcount[idclusters[i]-1] < ttc_cluster_bcount[idclusters[imin]-1]):
                    # Si no lo es, me guardo el i de idclusters como el nuevo minimo
                    imin = i

            for i in  range(len(idclusters)):
                if imin != i:
                    ttc_cluster_bcount[idclusters[i]-1] -= 1

            if show_classification:
                print "|| Balanced to ->", classified_title[1][imin], classified_title[2][imin]
            file_class.write(classified_title[1][imin]+"\n")

        else: # Only belongs to one cluster
            if show_classification:
                print
            file_class.write(classified_title[1][0]+"\n")
    else:
        if show_classification:
            print classified_title[0], "[Classification not found]"
        file_class.write("None\n")

print "Cluster count: ", ttc_cluster_count
print "Cluster balanced count: ", ttc_cluster_bcount

print
print "--- Cluster composition ---"

i = 0
for cluster in clusters:
    i += 1
    print "Cluster N" + str(i) + ": ", cluster

print
print "--- Clusters results ---"
i = 0
recall = 0
for result in results:
    i += 1
    print "Cluster N" + str(i) + ": " + str(result[0]) + " elements(" + str((result[0]/float(count))*100) + "%), " + str(result[1]) + " shared."
    recall += result[1]

print
print "--- Score analysis ---"
print "Total number of books: ", total
print "Books covered: ", (count/float(total))*100, "% (", count, "of", total, ")"
print "Recall: ", (float(recall)/count)*100
print "Score (0-100): ", (((count/float(total))*100) * (1-(float(recall)/count)))
print
