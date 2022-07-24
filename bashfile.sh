#! /bin/bash

# 1. Menggabungkan file
csvstack 2019-Oct-sample.csv 2019-Nov-sample.csv > join_data.csv

# 2. Menyeleksi kolom yang relevan
csvcut -c 2,3,4,5,7,8 join_data.csv > relevant_data.csv

# 3. Filtering purchase data
csvgrep -c "event_type" -m "purchase" relevant_data.csv > purchase_data.csv

# 4. Splitting category_code into category and product_name
## Filter category_code data
csvcut -c 3,6 join_data.csv | csvgrep -c "event_type" -m "purchase" | csvcut -c 2 > category_code.csv

## split into product_name and category
cut -d "." -f 1 category_code.csv | awk -F'\t' -vOFS='\t' '{ gsub("category_code", "category", $1) ; print }'  > category.csv

cut -d "." -f 2 category_code.csv | awk -F'\t' -vOFS='\t' '{ gsub("category_code", "product_name", $1) ; print }' > product_name.csv

## join purchase_data.csv, category.csv, and product_name.csv
paste purchase_data.csv category.csv product_name.csv -d "," > final_data.csv

