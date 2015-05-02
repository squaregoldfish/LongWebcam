To generate an HTML version of the Database Design document:

pandoc -s -S -t html5 --mathml --toc -c database_design.css -o ~/temp/database_design.html database_design.txt
