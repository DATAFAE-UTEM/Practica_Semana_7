# clean current workspace
rm(list=ls(all=T))

# set options
options(stringsAsFactors = F)

# install packages
install.packages("stringr")
install.packages("httr")
install.packages("jsonlite")

# activate packages
library(pdftools)
library(dplyr)
library(stringr)

# funcion para convertir muchos documentos PDF en txt
convertpdf2txt <- function(dirpath){
  files <- list.files(dirpath, full.names = T)
  x <- sapply(files, function(x){
    x <- pdftools::pdf_text(x) %>%
      paste(sep = " ") %>%
      stringr::str_replace_all(fixed("\n"), " ") %>%
      stringr::str_replace_all(fixed("\r"), " ") %>%
      stringr::str_replace_all(fixed("\t"), " ") %>%
      stringr::str_replace_all(fixed("\""), " ") %>%
      paste(sep = " ", collapse = " ") %>%
      stringr::str_squish() %>%
      stringr::str_replace_all("- ", "")
    return(x)
  })
}

# aplicamos la funcion
txts <- convertpdf2txt("C:\\Users\\panch\\Desktop\\python\\PDFs")


# inspect the structure of the txts element
str(txts)


# add names to txt files
names(txts) <- paste("text", 1:length(txts), sep = "")

# save result to disc
lapply(seq_along(txts), function(i)writeLines(text = unlist(txts[i]),
                                              con = paste("C:\\Users\\panch\\Desktop\\python\\PDF_txt/", names(txts)[i],".txt", sep = "")))

## funciona bien pero para PDFs que son imagenes no

#===========================================================================================#

#===========================================================================================#

#  con esto puedo sacar el texto de un PDF image

install.packages("tesseract")

library(tesseract)

pngfile <- pdftools::pdf_convert("C:\\Users\\marti\\OneDrive\\Desktop\\Datas\\PDf - Modelo extracción Py\\Archivo - 1.pdf", dpi = 600)
text <- tesseract::ocr(pngfile)
return(text)



library("wordcloud2")
library("tm")

# ruta donde tengo 100 pdf
my_dir = "C:\\Users\\marti\\OneDrive\\Desktop\\Datas\\PDf - Modelo extracción Py"

# se pasan los pdf a una lista
files <- list.files(path = my_dir, pattern = "pdf$")
files

# se crea un corpus
setwd(my_dir)

Data_text = Data.frame()

for (file in files){

  corp <- Corpus(URISource(file, encoding = "latin1"),
                 readerControl = list(reader = readPDF, language = "es-419"))

  pngfile <- pdftools::pdf_convert(file, dpi = 600)
  text <- tesseract::ocr(pngfile)
  cat(text)

  Data_text <- add_row()
  }


# guardo los nobres de los pdf en un vector
argumento <- names(corp)
argumento


# se hace una funcion que contenga la ruta de totos los PDFs_image

directorios <- data.frame()

for(nombre_archivo in argumento){
  directorio <- data.frame(
    ruta = paste("C:\\Users\\marti\\OneDrive\\Desktop\\Datas\\PDf - Modelo extracción Py", nombre_archivo, sep = "")
  )
  directorios <- rbind(directorios, directorio)
}

# funcion para hacer pasar las rutas por el extractor de texto
rutas <- directorios$ruta



