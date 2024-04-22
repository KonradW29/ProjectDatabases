'''
from SessionAnimalTrait.csv print a table of trait_code | count | description
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

# from SessionAnimalTrait.csv construct dict of trait_code:count
# csv attributes: session_id,animal_id,trait_code,alpha_value,alpha_units,when_measured,...
with open('SessionAnimalTrait.csv', newline='') as actfile:
    next(actfile) # skip first line
    actreader = csv.reader(actfile)
    counts = {}
    for row in actreader:
        # only count rows with a non-empty alpha_value
        if len(row[3]) > 0:
            # increment trait_code count; increment 0 if not found
            counts[row[2]] = counts.get(row[2], 0) + 1

# sort dictionary by count; returns list of (activity_code, count) tuples
sorted_counts = sorted(counts.items(), key=lambda kv: kv[1])

# pretty print tabular result
print("{: >8}{: >8}  {}".format('id', 'count', 'value'))
for tuple in sorted_counts:
    print("{: >8}{: >8}  {}".format(tuple[0], tuple[1], pickdict[tuple[0]]))