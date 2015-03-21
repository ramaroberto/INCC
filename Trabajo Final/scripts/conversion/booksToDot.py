#!/usr/bin/python
import re
import sys
import os.path
import operator

# Constants
qlimit = 100
catlimit = 200
relth = 90

def getEdgeString(id1, id2, weight, max_weight):
    penwidth = 15 * (weight/float(max_weight))
    return "  "+str(id1)+" -> "+str(id2)+" [penwidth="+str(penwidth)+"];\n"

def getNodeString(id, label, weight, max_weight):

    num_groups = 5
    val_division = max_weight/float(num_groups)
    group = int(weight/val_division)

    if group < 1:
        subgroup = int(weight/(val_division/2))

        if subgroup == 0:
            fontcolor = "black"
            color = 1
            height = 0.5
            width = 1.5
            fontsize = 20
        else:
            fontcolor = "black"
            color = 2
            height = 1
            width = 3
            fontsize = 35

    if group == 1:
        fontcolor = "black"
        color = 3
        height = 2
        width = 4
        fontsize = 45

    if group == 2:
        fontcolor = "white"
        color = 5
        height = 3
        width = 5
        fontsize = 55

    if group == 3:
        fontcolor = "white"
        color = 7
        height = 5
        width = 7
        fontsize = 70

    if group >= 4:
        fontcolor = "white"
        color = 9
        height = 5.5
        width = 7.5
        fontsize = 70

    return "  "+str(id)+" [label=\""+label+"\", fontcolor="+fontcolor+", color="+str(color)+", height="+str(height)+", width="+str(width)+", fontsize="+str(fontsize)+"];\n"

def addRelation(cat1, cat2, indexes, relations):
    icat1 = indexes[cat1]
    icat2 = indexes[cat2]
    if (icat1, icat2) in relations:
        relations[(icat1, icat2)] += 1
    else:
        relations[(icat1, icat2)] = 1

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

# Sort them
categories_items = categories.items()
sorted_categories = sorted(categories_items, key=operator.itemgetter(1,0), reverse=True)

# Inicializamos variables para la generacion del arff
file_in = open(source_fn, 'r')
file_out = open(target_fn, 'w')
catindex = {}
disc = 0

# Escribimos headers
file_out.write("digraph {\n  ratio=\"fill\";\n  size=\"20,15\";\n  layout=\"dot\";\n  overlap=false;\n  outputorder=\"edgesfirst\"\n  edge [arrowsize=1.5];\n  node [height=\"7\", width=\"9\", fontsize=80, fontcolor=white, color=1, style=filled, colorscheme=orrd9];\n")

# Escribimos nodos
banned_categories = ["Subjects", "General", "Formats", "Authors_A-Z", "Paperback", "Hardcover", "Reference", "Science", "Ages_9-12", "Books_on_Tape", "Books_on_CD", "Home_And_Office", "Business_And_Investing_Books", "Personal_Finance", "Business_And_Primers", "Categories", "Travel", "Military", "King_Stephen", "Entertainment", "Programming", "Parenting_And_Families", "Management_And_Leadership", "Biographies_And_Primers"]
max_quantity = 7000
for i in range(len(sorted_categories)):
    cat_display_name = sorted_categories[i][0]
    cat_name = cat_display_name.replace(" ", "_").replace("&", "And").replace(",", "")
    cat_quantity = sorted_categories[i][1]

    if (cat_name == "") or (cat_name in banned_categories) or (cat_name in catindex):
        disc += 1
        continue
    if cat_quantity < catlimit:
        break
    catindex[cat_name] = i-disc

    file_out.write(getNodeString((i-disc), cat_display_name, cat_quantity, max_quantity))

print "Generating DOT from " + str(len(catindex.items())) + " categories..."

# Computamos relaciones
relations = {}
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
            siblings_rel = []
            siblings_paths = []
            father_category = ""
            cat_path = []
            splitted = []
            k = 0
            for book_category in book_categories:
                sibling_category = None
                book_category = book_category.replace(" ", "_").replace("&", "And").replace(",", "")

                if book_category in catindex:

                    # Si la categoria es Books, una nueva rama comienza. Reinicio.
                    if book_category == "Books":
                        if len(cat_path) != 0:
                            siblings_paths.append(cat_path)
                        father_category = "Books"
                        cat_path = ["Books"]
                        splitted = [False for i in range(len(siblings_paths))]
                        k = 0
                    else:

                        # Si me separe de todas las anteriores ramas, agrego una relacion con el padre.
                        if reduce(operator.and_, splitted, True):
                            addRelation(father_category, book_category, catindex, relations)

                        # Busco los quiebres con las ramas anteriores y agrego relaciones de hermandad.
                        for j in range(len(siblings_paths)):
                            if not splitted[j]:
                                if len(siblings_paths[j]) <= k:
                                    splitted[j] = True
                                    continue
                                sibling_category = siblings_paths[j][k]
                                if sibling_category != book_category:
                                    splitted[j] = True
                                    if (book_category, sibling_category) not in siblings_rel:
                                        addRelation(book_category, sibling_category, catindex, relations)
                                        addRelation(sibling_category, book_category, catindex, relations)
                                        siblings_rel.append((book_category, sibling_category))
                                        siblings_rel.append((sibling_category, book_category))

                        # Registro el camino que voy haciendo.
                        cat_path.append(book_category)
                        father_category = book_category

                    k += 1

    if line.lstrip().rstrip() == '':
        cache = ""
        is_book = False

# Sort them
sorted_relations = sorted(relations.items(), key=operator.itemgetter(1,0), reverse=True)
max_relations = sorted_relations[0][1]

# Escribo las relaciones en el archivo
for relation in sorted_relations:
    weight = relation[1]
    if weight > relth:
        id1 = relation[0][0]
        id2 = relation[0][1]
        file_out.write(getEdgeString(id1, id2, weight, max_relations))

file_out.write("}")

file_in.close()
file_out.close()

print "DOT has " + str(len(sorted_relations)) + " relations."
print "Done!"
