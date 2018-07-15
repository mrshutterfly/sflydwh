import datetime

def in_dictlist(key, value, my_dictlist):
	"""
		Check is dict key, value exists in List of dicts
		Returns: Index of dictionary or -1 if dictionary doesn't exists
	"""

	for dict_index in range(len(my_dictlist)):
		if my_dictlist[dict_index].get(key) == value:
			return dict_index
	return -1
	
def Ingest(events, data = []):
	"""
		Process the customer events and build data dictonary for each customer 
		with cust details, site visits, image upload info and order info
		Input :
			events: events input in JSON format
			data: List of dictionaris, each dictionary contains all information about 
				  customer details and his/her site visists, Image upload, order details
		Returns: updated LIST with data
	"""
	
	for event in events:
		
		# Ingest data for event type of 'CUSTOMER'
		if event['type'] == 'CUSTOMER':
			# Build the dictionary with cust details
			cust_details = {
						'customer_id': event['key'], 
						'cust_event_time': event['event_time'], 
						'last_name': event['last_name'], 
						'adr_city': event['adr_city'],
						'adr_state': event['adr_state']
					}
			# As there is no guarantee that  all event types come in perticular order, Don't rely on verb(NEW, UPDATE) 		
			# Check if customer key already exists in data then update the attributes cust_event_time, last_name, adr_city, adr_state
			cust_index = in_dictlist('customer_id', event['key'], data)
			
			# If customer doesn't exist Insert to list else update 
			if cust_index == -1:
				data.append(cust_details)
			else:
				# Update the metrics from event type of 'CUSTOMER'
				data[cust_index]['cust_event_time'] = event['event_time']
				data[cust_index]['last_name'] = event['last_name']
				data[cust_index]['adr_city'] = event['adr_city']
				data[cust_index]['adr_state'] = event['adr_state']
		
		# Ingest data for event type of 'SITE_VISIT'			
		elif event['type'] == 'SITE_VISIT':
			# Build the dictionary with cust site visit details
			cust_site_visit_details = {
						'customer_id': event['customer_id'],
						'site_visits': [
							{
								'page_id': event['key'],
								'event_time': event['event_time'],
								'tags': event['tags']
							}
						]
					}
			
			# Check if customer key already exists in data then update the site_visits attributes
			cust_index = in_dictlist('customer_id', event['customer_id'], data)
			
			# If customer doesn't exist Insert to list else update 
			if cust_index == -1:
				data.append(cust_site_visit_details)
			else:
				# Update the metrics from event type of 'SITE_VISIT'
				# If the customer had already site visits, then add a entry to existing site visits
				# Else make a new entry to site visits
				if data[cust_index].get('site_visits') is None:
					data[cust_index]['site_visits'] = cust_site_visit_details.get('site_visits')
				else:
					data[cust_index]['site_visits'].append(cust_site_visit_details.get('site_visits')[0])
					
		# Ingest data for event type of 'IMAGE'	
		elif event['type'] == 'IMAGE':
			# Build the dictionary with cust image upload details
			cust_image_upload_details = {
						'customer_id': event['customer_id'],
						'image_uploads': [
							{
								'image_id': event['key'],
								'event_time': event['event_time'],
								'camera_make': event['camera_make'],
								'camera_model': event['camera_model']
							}
						]
					}
			
			# Check if customer key already exists in data then update the image_upload attributes
			cust_index = in_dictlist('customer_id', event['customer_id'], data)
			
			# If customer doesn't exist Insert to list else update 
			if cust_index == -1:
				data.append(cust_image_upload_details)
			else:
				# Update the metrics from event type of 'IMAGE'
				# If the customer had already image upload events, then add a entry to existing custome image upload events
				# Else make a new entry to image upload events
				if data[cust_index].get('image_uploads') is None:
					data[cust_index]['image_uploads'] = cust_image_upload_details.get('image_uploads')
				else:
					data[cust_index]['image_uploads'].append(cust_image_upload_details.get('image_uploads')[0])
		elif event['type'] == 'ORDER':
			# Build the dictionary with cust order details
			cust_order_details = {
						'customer_id': event['customer_id'],
						'orders': [
							{
								'order_id': event['key'],
								'event_time': event['event_time'],
								'total_amount': event['total_amount']
							}
						]
					}
					
			# Check if customer key already exists in data then update the image_upload attributes
			cust_index = in_dictlist('customer_id', event['customer_id'], data)
			
			# If customer doesn't exist Insert to list else update 
			if cust_index == -1:
				data.append(cust_order_details)
			else:
				# Update the metrics from event type of 'IMAGE'
				# If the customer had already image upload events, then add a entry to existing custome image upload events
				# Else make a new entry to image upload events
				if data[cust_index].get('orders') is None:
					data[cust_index]['orders'] = cust_order_details.get('orders')
				else:
					# Check the order already exist or not. If exists then update the order detail
					# else insert the order
					order_index = [index for index in range(len(data[cust_index]['orders'])) if event['key'] in data[cust_index]['orders'][index].get('order_id')]
					if len(order_index) == 0:
						data[cust_index]['orders'].append(cust_order_details.get('orders')[0])
					else:
						# pop the old order details and reinsert the updated order
						data[cust_index]['orders'].pop(order_index[0])
						data[cust_index]['orders'].append(cust_order_details.get('orders')[0])
		else:
			raise ValueError("Invalid Event Type. Exitting..")
			
	return data
	
def TopXSimpleLTVCustomers(x, D):
	"""
	For given Datastructure with all injested event return 
	Top x customers details like customer_id, last_name, adr_city, adr_state and LTV
	returns: List of dictionaries with customer details and LTV
	"""
	
	"""
	while calculating LTV, I assume that we have to consider total number of weeks for any customer is 
	the number of weeks between first site vist for any customer and last site visit for any customer
	Following are steps I did to caluclate LTV
	
	1. Determine the number of weeks by subtracting last site visit timestamp with first site visit of all customers and divide by 7
	   This value(number of weeks ) will be used to determine #visitsperweeks of customer.
	2. Find the total visits and cust_visits_per_week(total visits/#weeks)
	3. cust_expendeture_per_visit is caluclate using formula (sum(order_amount)/total_visits)
	4. Finally 52 * (cust_expendeture_per_visit * cust_visits_per_week) * 10 is the LTV of customer
	"""
	
	cust_LTV = []
	
	# Check the Data is empty. If input is empyty the output will be empty
	if len(D) == 0:
		return cust_LTV
		
	# Flatten all the site event timestamps to get the number of weeks
	# Some customers may not have site visits in the given timeframe of dataset
	site_events = [se.get('site_visits') for se in D if se.get('site_visits') is not None]
	site_event_times = [event_times.get('event_time') for cust_all_site_events in site_events for event_times in cust_all_site_events]
	
	# Get year and week of year from the events
	# Convert the event_time to python timestamp and get the year and clander
	year_week = [datetime.datetime.strptime(event_time, "%Y-%m-%d %H:%M:%S.%f").isocalendar()[:2] for event_time in site_event_times]
	
	# Get the week count by removing duplicates
	week_count = len(set(year_week))
	
	# For each customer calculate the LTV
	
	t = 10
	for customer in D: 
		# Iterate over each customer in List
		cust_LTV_details = {}
		# Get total visits of customer by getting count of site_visits
		total_visits = len(customer.get('site_visits')) if customer.get('site_visits') is not None else 0
		visits_per_week = (total_visits*1.0)/week_count
		
		# Get total orders amount of customer
		total_amount = sum([orders.get('total_amount') for orders in customer.get('orders')]) if customer.get('orders') is not None else 0
		cust_expendeture_per_visit =  ((total_amount*1.0)/total_visits) if total_visits != 0 else 0
		
		LTV = round(52 * (cust_expendeture_per_visit * visits_per_week) * t, 2)
		cust_LTV_details['customer_id'] = customer.get('customer_id')
		cust_LTV_details['last_name'] = customer.get('last_name')
		cust_LTV_details['adr_city'] = customer.get('adr_city')
		cust_LTV_details['adr_state'] = customer.get('adr_state')
		cust_LTV_details['LTV'] = LTV
		cust_LTV.append(cust_LTV_details)
		
	# Sort the list of dictionaries by 	customer LTV in DESC ordering
	cust_LTV_sorted = sorted(cust_LTV, key=lambda cust: cust['LTV'], reverse=True)
	
	# Return the sorted list of dictionaries if x is greater than the length of the list 
	# else return first x elements 
	return cust_LTV_sorted if len(cust_LTV_sorted) <= x else cust_LTV_sorted[:x]
