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

  # Extracción de fecha
  Fecha = corp[[ file ]][["meta"]][["datetimestamp"]]

  # Transformación del texto
  pngfile = pdftools::pdf_convert(file, dpi = 600)
  Texto = tesseract::ocr(pngfile)
  cat(Texto)

  # Transformación lista a párrafo
  Full_Texto <- ""

  for (i in Texto) {
    Full_Texto <- paste(Full_Texto, i)
  }

  Texto <- Full_Texto
  rm(Full_Texto)

  # Unión y limpieza
  Texto_limpio = Texto %>% paste(sep = " ") %>%
                      stringr::str_replace_all(fixed("\n"), " ") %>%
                      stringr::str_replace_all(fixed("\r"), " ") %>%
                      stringr::str_replace_all(fixed("\t"), " ") %>%
                      stringr::str_replace_all(fixed("\""), " ") %>%
                      paste(sep = " ", collapse = " ")
  cat(Texto_limpio)

  # Construccion Dataset
  Data_text <- rbind(Data_text, data.frame(Archivo, Fecha, Texto, Texto_limpio))
}

write.csv2(Data_text, "C:\\Users\\marti\\OneDrive\\Desktop\\Datas\\Data Profe Diana\\Data_text.csv" )


