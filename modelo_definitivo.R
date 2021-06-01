library(tesseract)

pngfile <- pdftools::pdf_convert("C:\\Users\\panch\\Desktop\\python\\PDFs\\archivo - 2021-05-07T124627.929.pdf", dpi = 600)
text <- tesseract::ocr(pngfile)
cat(text)



library("wordcloud2")
library("tm")
library("pdftools")
library("tidyverse")
library("dplyr")

# ruta donde tengo 100 pdf
my_dir = "C:\\Users\\panch\\Desktop\\python\\PDFs"

# se pasan los pdf a una lista
files <- list.files(path = my_dir, pattern = "pdf$")
files

##============================================##
# LIMPIEZA DEL CORPUS #
corp <- tm_map(corp, content_transformer(tolower))
corp <- tm_map(corp, content_transformer(removePunctuation))
corp <- tm_map(corp, content_transformer(removeNumbers))
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, stripWhitespace)

# guardo los nobres de los pdf en un vector
argumento <- names(corp)

# se crea un corpus
setwd(my_dir)

Data_text = data.frame()

for (file in files){
  
  archivo = file
  
  corp <- Corpus(URISource(file, encoding = "latin1"),
                 readerControl = list(reader = readPDF, language = "es-419"))
  
  pngfile <- pdftools::pdf_convert(file, dpi = 600)
  text <- tesseract::ocr(pngfile)
  cat(text)
  
  fecha = corp[[ file ]][["meta"]][["datetimestamp"]]
  
  Data_text <- rbind(Data_text, data.frame(archivo, fecha, text))
}




