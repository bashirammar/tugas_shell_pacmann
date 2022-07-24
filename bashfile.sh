#! /bin/bash

csvstack 2019-Oct-sample.csv 2019-Nov-sample.csv > join_data.csv

csvcut -c 2,3,4,5,7,8 join_data.csv > relevant_data.csv

csvgrep -c "event_type" -m "purchase" relevant_data.csv > purchase_data.csv

csvcut -c 3,6 join_data.csv > category_code.csv

csvgrep -c "event_type" -m "purchase" category_code.csv > category_purchase.csv

csvcut -c 2 category_purchase.csv > category_only.csv

cut -d "." -f 1 category_only.csv > category_name.csv

cut -d "." -f 2 category_only.csv > product_name.csv

awk -F'\t' -vOFS='\t' '{ gsub("category_code", "product_name", $1) ; print }' product_name.csv > product_final.csv

awk -F'\t' -vOFS='\t' '{ gsub("category_code", "category", $1) ; print }' category_name.csv > category_final.csv

paste purchase_data.csv category_final.csv product_final.csv -d "," > final_data.csv



