
# take sample csv file and add quotations around every element

import csv

with open('your file name.csv', 'r') as file_in:
	reader = csv.reader(file_in, delimiter = ',')
	with open ('your file name.csv', 'w') as file out:  # set output file
    # writer method to put quotes around each entry as ' '
		writer = csv.writer(file_out, quoting = csv.QUOTE_ALL,
			quotechar = "'", lineterminator = "\n")  # add line terminator at end of file
		for row in reader:
			if reader.line_num != 1:   # if line is not 1 (!=1) then: write all but header row
				writer.writerow(row)
