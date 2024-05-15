# Ctrl. F ++
## TLDR
Every student and professional has to work with large pdf files.
One very common problem is finding the specific thing that you are looking for inside
one or multiple pdf files.
Usually, we just open the files in our preferred browser or Adobe, 
press Ctr.+ F and hope for the best.
The problem is, that feature is not very powerful. 
It doesn't even work for fuzzy searches, and therefore if you make a single typo,
it won't return any results

Ctrl. F ++ is a linux CLI tool which leverages Google's Universal Sentence Encoder to
search one or multiple pdf documents. The usage is very simple, you simply have to run the script
`main.sh` and specify what you want to search and the path to the pdf(s) where you want to search.
```bash
./src/main.sh 'search-string' pdf1 [pdf2 ...]
```
For example:
```bash
./src/main.sh "multi-storey housing law" ~/Documents/UK-law.pdf  ~/Documents/England-law.pdf
```
This works well for exact matches, fuzzy searches, and more complex non-exact searches.
It even does a solid job responding to some simple questions 
e.g. `./main.sh 'where can i find the uk housing law'`.

Here is a video demonstrating the tool with the docs of Geant4,
a popular particle physics library.

[cfpp-demo.webm](https://github.com/perezsergio/cfpp/assets/129288111/927a2947-a4b1-4d0e-82d5-c415c0eff817)




## How it works
First, the unix utility `pdftotext` is used to convert the pdf files to plain text.
Then, `nltk` is used to divide the plain text into sentences. 
After that, Google's nlp model 'USE' is used to find the top 5 sentences in the text
that have the highest similarity with the search string.
Finally, some bash and python logic is used to find the document, page and paragraph
where each of the top 5 matches belong, and a couple bash functions are used to print
all the information to stdout in a nice organized way.


## Package requirements 
I'm working on creating a docker container so that anyone can use this utility. 
In the mean time, it is only available for linux users.

Apart from built-in bash utilities, this repo only uses one unix CL utility: pdftotext.
It comes with most modern Linux distributions, and if even if it doesn't it's very simple 
to install it with your preferred package manager. For example in ubuntu:
```bash
sudo apt install pdftotext 
```

The repo does make a heavy use of python packages. 
The files `requirements.txt` and `environment.yml`record the necessary libraries.
If you are using conda:
```bash
conda env create -f environment.yml
```
If you prefer pip:
```bash
pip install -r requirements.txt
```



