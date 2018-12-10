#!/usr/bin/python3

import sys, os
import csv
#import re

def create_outfile(infile, extension):
    try:
        infile_list = infile.split('.')[:-1]
        infile_name = infile_list.pop(0)
        for i in infile_list:
            print(i)
            infile_name += '.{}'.format(i)
        infile_extension = infile.split('.')[-1]
    except:
        print("check input file")
        sys.exit()
    outfile = infile_name + extension
    return outfile

def clean_data(infile):
    with open(infile) as line_data:
        cr = csv.reader(line_data, delimiter = ',')
        data = list(cr)
        
        outfile = create_outfile(infile, "_cleaned.csv")
        with open (outfile, 'w') as outfile:
            writer = csv.writer(outfile, delimiter = ',')
            header = []
            writer.writerow(header)
            
            for i in data:
                if len(i[0]):
                    row = []

                    # DO STUFF
                    
                    writer.writerow(row)
    
if __name__ == "__main__":
    clean_data(sys.argv[1])
