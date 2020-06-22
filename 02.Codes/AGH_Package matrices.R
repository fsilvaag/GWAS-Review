library(AGHmatrix)
library(data.table)
library(tidyverse)
library(openxlsx)
library(reshape2)
rm(list = ls())
path1 = "https://raw.githubusercontent.com/fsilvaag/GWAS-Review/master/01.%20Databases/"
gbs <- as.data.frame(fread(paste0(path1,"Numerical012.txt.gz"), 
                            header = T))

gbs <- gbs %>% remove_rownames() %>% column_to_rownames(var = "SNP")

G_VanRaden <- Gmatrix(as.matrix(gbs), method = "VanRaden", ploidy = 2)

#data.table::fwrite(as.data.frame(G_VanRaden), paste0(path,"GMatrix_VanRaden.csv"),quote = F, row.names = T, sep=",")

## Reformating the Kinship matrix
GV <- melt(G_VanRaden, id.vars = rownames(G_VanRaden))



