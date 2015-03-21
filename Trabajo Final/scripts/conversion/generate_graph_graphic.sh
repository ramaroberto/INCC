#!/bin/bash
./booksToDot.py ../../resources/amazon-meta.txt ALL graph.dot && dot -Tpdf graph.dot -o ../../results/graph.pdf