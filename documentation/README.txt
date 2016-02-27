This repository contains all the documentation for the project, along with
miscellaneous items such as logo files.

Documents are written in Markdown, designed to be processed by pandoc.

To generate an HTML version of the specification document:

pandoc -s -S -t html5 --mathml --toc -c lwc_doc.css -o <output>.html <doc_file>.md

The HTML file will use lwc_doc.css for formatting, and assumes that it will be
in the same folder.

For a LaTeX-based PDF:

pandoc -s <doc_file>.md -o <output>.pdf

For a Word document:

pandoc -s -S <doc_file>.md -o <output>.docx
