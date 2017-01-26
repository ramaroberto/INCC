#1. Cargar el archivo de palabritas en un diccionario en Python
#2. Cargar un set con las stopwords en Python
#3. Cargar un libro y hacerle tokenizacion, como resultado te tiene que quedar una lista de palabras
#4. Tenes una variable suma inicializada en cero y por cada palabra de la lista si no esta en el set stopwords y esta en el diciconario entonces sumas lo que este en el diccionario
#5. Dividis la variable de suma por la cantidad de palabras
import glob
import nltk
from math import log
from nltk.tokenize import word_tokenize
#nltk.download('punkt')
import sys
reload(sys)
sys.setdefaultencoding('utf8')

#load dictionary
dict = {}
with open("wiv.cnt") as f:
    for line in f:
       (key, val) = line.split(' ')
       dict[key] = int(val)

#load stopWords
stopWords = set(line.strip() for line in open('stopWords.cnt'))

#load books and calculate simplicity
for filename in glob.glob('*.txt'):
    sum = 0
    nbOfWords = 0
    myBook = open(filename).read()
    tokens = word_tokenize(myBook)
    myBookWoStopWords = set()
    for i in tokens:
        if i not in stopWords and i in dict:
            nbOfWords += 1
            sum += log(dict[i]+1)
    res = filename + ': ' + repr(sum/nbOfWords)
    print(res)
