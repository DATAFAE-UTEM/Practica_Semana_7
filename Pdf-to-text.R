# clean current workspace
rm(list=ls(all=T))

# set options
options(stringsAsFactors = F)

# install packages
install.packages("tesseract")
install.packages("pdftools")
install.packages("tidyverse")
install.packages("wordcloud2")
install.packages("tm")


# Activate packages
library(tesseract)
library(pdftools)
library(wordcloud2)
library(tm)
library(tidyverse)

#===========================================================================================#
                                  # EXTRACCIÓN DE TEXTO #
#===========================================================================================#

# MODELO PARA DOCUMENTOS FORMATO PDF #

# Creación de Data y definición de url
Data_text = data.frame()
my_dir <- ("Directorio de los archivos .PDF")

# Extracción del texto
files <- list.files(path = my_dir, pattern = "pdf$")
setwd(my_dir)

for (file in files){

  # Nombre de archivo
  Archivo = file

  # Estructura de Corpus
  corp = Corpus(URISource(file, encoding = "latin1"),
                readerControl = list(reader = readPDF, language = "es-419"))

  # Transformación del texto
  pngfile = pdftools::pdf_convert(file, dpi = 600)
  Texto = tesseract::ocr(pngfile)
  cat(Texto)

  # Extracción de fecha
  Fecha = corp[[ file ]][["meta"]][["datetimestamp"]]

  # Construccion Dataset
  Data_text <- rbind(Data_text, data.frame(Archivo, Fecha, Texto))
}


