'''
from SessionAnimalActivity.csv print a table of activity_id | count | description
John DeGood; 7 Feb 2024
'''

import csv

# from PicklistValue.csv construct dict of picklistvalue_id:value
# csv attributes: picklistvalue_id,picklist_id,value
with open('PicklistValue.csv', newline='') as pickfile:
    next(pickfile) # skip first line
    pickreader = csv.reader(pickfile)
    pickdict = {}
    for row in pickreader:
        # add entry picklistvalue_id:value
        pickdict[row[0]] = row[2]

# from SessionAnimalActivity.csv construct dict of activity_code:count
# csv attributes: session_id,animal_id,activity_code,when_measured,...
with open('SessionAnimalActivity.csv', newline='') as actfile:
    next(actfile) # skip first line
    actreader = csv.reader(actfile)
    counts = {}
    for row in actreader:
        # increment activity_code count; increment 0 if not found
        counts[row[2]] = counts.get(row[2], 0) + 1

# sort dictionary by count; returns list of (activity_code, count) tuples
sorted_counts = sorted(counts.items(), key=lambda kv: kv[1])

# pretty print tabular result
print("{: >8}{: >8}  {}".format('id', 'count', 'value'))
for tuple in sorted_counts:
    print("{: >8}{: >8}  {}".format(tuple[0], tuple[1], pickdict[tuple[0]]))