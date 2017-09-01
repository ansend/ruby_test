#! /bin/bash

count=2

for ((i=1; i<=count; i ++))     
do      
	 echo $i  
	   ./multiclient.rb > log${i}  2>&1 &
done      
