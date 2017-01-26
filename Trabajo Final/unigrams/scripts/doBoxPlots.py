#!/usr/bin/env python
import glob, os, csv
from ast import literal_eval as make_tuple
import matplotlib as mpl
mpl.use('agg')
import matplotlib.pyplot as plt

def doPlot(vbs, name="fig"):
    plt.clf()
    data_to_plot = []
    keys = sorted(vbs.keys())
    for key in keys:
        data_to_plot.append(vbs[key])
    
    if name == "Kincaid":
        print "Distribution: "
        labels_x = [1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
        for i in range(len(keys)):
            print labels_x[i], len(data_to_plot[i])
        print "\nStarting plot output..."
    
    # Adds together the 1.5, 2.0 and 2.5
    labels_x = ["1.5-2.5", "3.0", "3.5", "4.0", "4.5", "5.0"]
    data_to_plot = [reduce(lambda x,y: x+y, data_to_plot[0:3])] + data_to_plot[3:]
    
    # Create a figure instance
    plt.title(name)
    fig = plt.figure(1, figsize=(9, 6))
    # Create an axes instance
    ax = fig.add_subplot(111)
    # Create the boxplot
    bp = ax.boxplot(data_to_plot)
    plt.xticks([1, 2, 3, 4, 5, 6], labels_x)
    # Save the figure
    fig.savefig(name+".png", bbox_inches='tight')


starting = 3
number = 8
labels = ["Kincaid","ARI","Coleman-Liau","FleschReadingEase","GunningFogIndex",\
    "LIX","SMOGIndex","RIX","characters_per_word","syll_per_word","words_per_sentence",\
    "sentences_per_paragraph","type_token_ratio","characters","syllables","words",\
    "wordtypes","sentences","paragraphs","long_words","complex_words","tobeverb",\
    "auxverb","conjunction","pronoun","preposition","nominalization",\
    "interrogative","article","subordination"]

metrics = range(starting, number+starting)
labels = labels[0:number+1]
for metric in metrics:
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
    
    doPlot(values_by_scores, str(labels[metric-starting]))
    print "Finished plot for metric \"" + labels[metric-starting] + "\""

print "All plots finished."
