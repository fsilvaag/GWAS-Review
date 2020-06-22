rm(list = ls())
path <- "https://raw.githubusercontent.com/fsilvaag/GWAS-Review/master/03.Output_Files/"
d <- openxlsx::read.xlsx(paste0(path,"Associated_SNPs.xlsx"), 
                         sheet = "Plant Height")
vd <- d[,c("SNP","Chromosome","Method","Kinship")]


library(tidyverse)
library(hrbrthemes)
library(tm)
library(proustr)
library(VennDiagram)
vd$Categ <- paste0(vd$Method,"_",vd$Kinship)

#FarmCPU gives the same SNP for both Kinships
venn.diagram(list(
  FarmCPU_G = subset(vd,vd$Categ == "FarmCPU_G Matrix")$SNP,
  #FarmCPU_IBD = subset(vd,vd$Categ == "FarmCPU_IBDLD")$SNP,
  SUPER_G = subset(vd,vd$Categ == "SUPER_G Matrix")$SNP,
  SUPER_I = subset(vd,vd$Categ == "SUPER_IBDLD")$SNP), 
  fill = c("lightblue","red","lightgreen"),
  alpha = c(0.5,0.5,0.5), lwd = 0.5, 
  filename = "venn_PH.tiff",
  #imagetype="png" ,
  #height = 1080 , 
  #width = 2080 , 
  resolution = 330
)


