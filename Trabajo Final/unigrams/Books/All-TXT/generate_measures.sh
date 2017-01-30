#!/bin/bash
readability --csv --tokenizer='tokenizer -L en-u8 -P -S -E "" -N' *.txt >readabilitymeasures.csv
