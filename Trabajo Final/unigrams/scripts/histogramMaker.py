#!/usr/bin/env python
import matplotlib.pyplot as plt

labels = ["1.0","1.5","2.0","2.5","3.0","3.5",\
		"4.0","4.5","5.0"]

myData = []
with open('../Books/amazonDBBooksInfo.txt', 'r') as file:
	for line in file:
		data = line.split(",")
		score = float(data[1])
		myData.append(score)

plt.clf()
plt.xlabel("Puntaje")
plt.ylabel("Cantidad")
plt.title("Distribucion de libros segun puntaje en Amazon")
fig = plt.figure(1, figsize=(9, 6))
# Create an axes instance
ax = fig.add_subplot(111)
# Create the histogram
bp = ax.hist(myData, bins = 8, rwidth = 0.7, color = 'green')
# Save the figure
fig.savefig("histogram"+"/"+"histogramaPuntajeAmazon"+".png")
