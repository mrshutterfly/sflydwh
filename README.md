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
      4. sql code is in src/sql/customer_lifetime_value.sql and execution output is located in output/customer_lifetime_value.out
      3. To caluclate LTV i used below logic for both SQL/python.
      
          - Determine the number weeks from dataset i.e. sitevisits(#weeks(calander) between first site visit and last site visit for all customers)
          - calculate total visits per customer and customer site visits per week(total_visits/#weeks)
          - Calculate customer expendeture per visit(total_order_amount/total_site_visits)
          - Calculate customer LTV by using formule 52 * (cust_expendeture_per_visit * cust_visits_per_week) * 10.0
      
       

