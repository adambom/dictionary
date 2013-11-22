English Language Dictionary
================================

This repository houses the contents of Webster's Unabridged English Dictionary.

The dictionary can be found in plain text form [here](http://www.gutenberg.org/ebooks/29765)

You'll also find some julia files that were used to parse the text and organize it into the nice
json you see here.

# Contents
- dictionary.json: This is the raw data scraped from the dictionary. Unsurprisingly, it's in the format
of a dictionary, i.e. ```{ "Word": "Definition" }```
- graph.json: This is a graph representation of the dictionary. Each word is paired with a list of the
words that define it
- dictionary.txt: This is the plain text file (I converted it from ISO-8859-1 to UTF-8)
- main.jl: The julia script that parses the data
- _.jl: My in-progress implementation of underscore in julia

# How to run
If you want to run the code yourself, I would recommend downloading [Julia Studio](http://forio.com/julia),
which is and IDE for Julia. It comes with the binaries pre-installed. You can also get the binaries or build
from source from [julialang.org](http://julialang.org).

# License
The works in this repository are licensed under the MIT License, with the exception of the contents of dictionary.txt, which are licensed under the terms of the Project Gutenberg License:

From Project Gutenberg:
> This eBook is for the use of anyone anywhere at no cost and with
> almost no restrictions whatsoever.  You may copy it, give it away or
> re-use it under the terms of the Project Gutenberg License included
> with this eBook or online at www.gutenberg.net