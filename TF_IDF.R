#=================================================================================================#
                                           #    TF-IDF   #
#=================================================================================================#

# librerias 
library(tm)
library(ggplot2)

# Ruta con PDFs
my_dir <- "C:\\Users\\panch\\Desktop\\python\\pdf"

# se pasan los pdf a una lista
files <- list.files(path = my_dir, pattern = "pdf$")
files

# se crea un corpus
setwd(my_dir)
corp <- Corpus(URISource(files, encoding = "latin1"),
               readerControl = list(reader = readPDF, language = "es-419"))

# cantidad de archivos
length(corp)

# stopwprds personalizadas
myStopwords = c( stopwords("spanish"),"Carlos","Pavez","Tolosa")

# TDM aplicando la ponderación TF-IDF en lugar de la frecuencia del término
tdm = TermDocumentMatrix(corp,
                         control = list(weighting = weightTfIdf,
                                        stopwords = myStopwords, 
                                        removePunctuation = T,
                                        removeNumbers = T))
tdm
inspect(tdm)

# frecuencia con la que aparecen los términos sumando el contenido de todos los términos (es decir, filas)
freq <- rowSums(as.matrix(tdm))
head(freq,10)
tail(freq,10)

# Trazar las frecuencias ordenadas
plot(sort(freq, decreasing = T),col="blue",main="Word TF-IDF frequencies", xlab="TF-IDF-based rank", ylab = "TF-IDF")

# 10 terminos mas frecuentes
tail(sort(freq),n=10)

# Términos más frecuentes y sus frecuencias en un diagrama de barras.
high.freq <- tail(sort(freq),n=10)
hfp.df <- as.data.frame(sort(high.freq))
hfp.df$names <- rownames(hfp.df) 

ggplot(hfp.df, aes(reorder(names,high.freq), high.freq)) +
  geom_bar(stat="identity") + coord_flip() + 
  xlab("Terms") + ylab("Frequency") +
  ggtitle("Term frequencies")
