#!/usr/bin/env python
import glob, os, csv
from ast import literal_eval as make_tuple
import matplotlib as mpl 
mpl.use('agg')
import matplotlib.pyplot as plt 

def doPlot(vbs, name="fig"):
	data_to_plot = []
	keys = sorted(vbs.keys())
	for key in keys:
		print key
		data_to_plot.append(vbs[key])

	for i in range(len(keys)):
		print keys[i], len(data_to_plot[i]), data_to_plot[i]

	# Create a figure instance
	fig = plt.figure(1, figsize=(9, 6))
	# Create an axes instance
	ax = fig.add_subplot(111)
	# Create the boxplot
	bp = ax.boxplot(data_to_plot)
	plt.xticks([1, 2, 3, 4, 5, 6, 7, 8], [1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0])
	# Save the figure
	fig.savefig(name+".png", bbox_inches='tight')


starting = 3
number = 18
metrics = range(starting, number)
labels = ["3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"]
for metric in metrics:
	i = 0
	values_by_scores = {}
	with open('filesRatingsScores.csv', 'r') as file:
		for line in file:
			data = line.split(",")
			score = float(data[1])
			value = float(data[metric])
			if score not in values_by_scores:
				values_by_scores[score] = [value]
			else:
				values_by_scores[score].append(value)
			i += 1
	
	doPlot(values_by_scores, str(labels[metric-starting]))
	print "Finished plot of metric " + labels[metric-starting]

