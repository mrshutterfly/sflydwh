# sflydwh
Solve the Shutterfly DWH code chalenge:

       This code challenge implemented with SQL and python solution.
       
 SQL solution:
 
      For SQL challenge I implemented using postgres SQL (Redshift/Netezza/PostgresDB). Data for relational tables is populated 
      using INSERT statement. The following variations of data generated.
      
      1. All customers information will be in customers table. 
      2. All customer site visits are loaded in sitevisits table. Some customers may not have site visits in input events. 
         Some customers will have events all the weeks and some customers may not have site visits  in few weeks.
         I considered site visits between 2017-12-25 and 2018-01-28
      3. for this Solution I considered as calander week as week i.e Jan 1-7 (1st week), Jan 8-14(2nd week) etc.
      4. All image upload information will be in imageuploads table 
      5. Order information will be in orders table
      6. sql code is in src/sql/customer_lifetime_value.sql and execution output is located in output/customer_lifetime_value.out
      7. To caluclate LTV i used below logic for both SQL/python.
      
          - Determine the number weeks from dataset i.e. sitevisits(#weeks(calander) between first site visit and last site visit for all customers)
          - calculate total visits per customer and customer site visits per week(total_visits/#weeks)
          - Calculate customer expendeture per visit(total_order_amount/total_site_visits)
          - Calculate customer LTV by using formule 52 * (cust_expendeture_per_visit * cust_visits_per_week) * 10.0
      
     
 Python solution:
 
      Ingest function: Ingest(e, D)
      
          1. For Ingest function event(s) and in memory data structure(list of dictionaries where dict contains customer sitevists/image uploads/order details) will be passed as input and updated in memory data structure will return.
          2. List of all input events available in file input/events.json
          3. For validation purpose i wrote the output of Ingest function to file which is available in output/cust_ds.json
          4. Comments are added in function
          
     TopXSimpleLTVCustomers(x, D):
     
         1. Calculate the LTV for each customer  using logic described in SQL solution.
         2. if x is greater than number of customers in dataset the ouput will be list of all customers in desc order of LTV value else will dispaly top x customers in DESC orderof LTA value
         3. For validation purpose i wrote the output of Ingest function to file which is available in output/top_x_ltv_cust_ds.json
         
         
         I tested the both functions by invoking the function in script driver.py
         
  Performance considerations:
  
        1. Data ingest and TopXSimpleLTVCustomers functions will perform operations in sequence. With huge volume of customers execution will take more time. To improve performance we can consider Threadpool to Ingest/calculateLTV which will execute functions in parallel
        2. use Big data Frame work like Apache Spark when we processing huge data volumes
        
  How to execute:
  
        1. clone the project in workspace using command git clone https://github.com/mrshutterfly/sflydwh.git
        2. To execute SQL file please perform below steps.
        
             . cd to src/sql
             . run the sql script from command line using psql --host <hostname> --user <username> --port <portnum> <dbname> -f customer_lifetime_value.sql -o ../../output/customer_lifetime_value.out
             
       3. To execute the python solution perform the below steps.
       
             . cd to src/python
             . run command python driver.py
             . The ouput for validation can be viewed in output/cust_ds.json and output/top_x_ltv_cust_ds.json
        
          
          
      
             

