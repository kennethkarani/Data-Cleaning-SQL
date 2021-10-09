# Data-Cleaning-SQL

This is a project cleaning a large dataset on housing in Nashville using SQL Queries. The data is messy making it perfect to clean up.

These are the processes that will take place. 

1. Changing the date format from date time to just the date without the time.
2. Fixing some of the null property address that should not be null.
3. The address columns combine the address, city, and state but I want to seperate each of these in their own columns. Address. City. State.
4. Removing 'Y' and 'N' and replacing them with 'Yes' and 'No'.
5. Removing duplicate rows that have the exact same information (must have been double entry)
6. Deleting unused columns that offer no useful information. 
