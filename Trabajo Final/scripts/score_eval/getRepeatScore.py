#!/usr/bin/python
import re
import sys
import os.path
import math


# If not enough parameters are provided
if len(sys.argv) < 2:
    print "[Error] Ingrese el nombre del archivo."
    quit()

source_fn = sys.argv[1]

# Check for existence
if not os.path.exists(source_fn) or not os.path.isfile(source_fn):
    print "[Error] Source file doesn't exist."
    quit()
file_in = open(source_fn, 'r')

data = file_in.read()

# Cargamos el diccionario
fdict = open("my.dict", 'r')
dictionary = []
for line in fdict:
	dictionary.append(line[0:-1])


# La metrica funciona de la siguiente manera:
# Sea v_i la palabra i del vocabulario del libro
# Sea C(v_i) = cantidad de veces que aparece la palabra v_i en el libro
# ponderacion = sum(v_i in V){ log(1/C_(v_i)) } - log(D)
#                   donde D es la cantidad de palabras en el diccionario
# Es decir que a menor puntaje, mayor cantidad de palabras repetidas

score = 0
cwords = {}
totalCounterVocabulary = 0


# Procesamos las palabras
wordBooks = data.lower().split()
for i in range(0,len(wordBooks)):
    word = re.sub("[^a-z]", "", wordBooks[i])
    wordBooks[i] = word
    if word in dictionary:
        if word in cwords:
            cwords[word] += 1
        else:
            cwords[word] = 1
            totalCounterVocabulary += 1

for word in cwords.keys():
    score += math.log(1/float(cwords[word]))
#score -= math.log(len(dictionary))
#score = math.exp(score)

# Es la cantidad de vocabulario total registrado sobre el vocabulario del libro
# De esta forma libros con un vocabulario pobre se les aplica un multiplicador
# mayor de forma tal que su puntaje quede mas bajo que libros que tienen una
# mayor riqueza de vocabulario. De cierta forma se los divide en modulos.
score *= float(len(dictionary))/totalCounterVocabulary

print "Score de repeticiones:", score
