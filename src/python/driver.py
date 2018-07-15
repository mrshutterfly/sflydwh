import os
import json
from customer_acquisition import *

# Load the input events

input_file = '..' + os.sep + '..' + os.sep + 'input' + os.sep + 'events.json'
 
with open(input_file) as events_input:
	events = json.load(events_input)

# Ingest the events into in memory data structure
cust_events = []

cust_events = Ingest(events, cust_events)
cust_events_json = json.dumps(cust_events, indent=4)

# Write injested data to file
outfile = '..' + os.sep + '..' + os.sep + 'output' + os.sep + 'cust_ds.json'
open(outfile, 'w').write(cust_events_json) 
#print(cust_events_json)

# Calculate top x customers with the highest Simple Lifetime Value from data D.
top_customers = TopXSimpleLTVCustomers(3, cust_events)
top_customers = json.dumps(top_customers, indent=4)

outfile = '..' + os.sep + '..' + os.sep + 'output' + os.sep + 'top_x_ltv_cust_ds.json'
open(outfile, 'w').write(top_customers)
