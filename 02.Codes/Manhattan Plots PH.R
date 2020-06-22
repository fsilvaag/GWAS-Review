library(qqman); library(openxlsx); library(tidyverse)
rm(list = ls())
path <- "https://raw.githubusercontent.com/fsilvaag/GWAS-Review/master/03.Output_Files/Models_Output/"

## Importing datasets
# SUPER
##IBDLD
SUPER_IBDLD <- as.data.frame(fread(paste0(path,"IBDLD.GAPIT.SUPER.PH.GWAS.Results.csv")))

SUPER_IBDLD_No3 <- as.data.frame(fread(paste0(path,"Subset_3SNPs_IBDLD.GAPIT.SUPER.PH.GWAS.Results.csv")))


## G Matrix
SUPER_G_Mat <- as.data.frame(fread(paste0(path,"G_Mat.GAPIT.SUPER.PH.GWAS.Results.csv")))

SUPER_G_Mat_No3 <- as.data.frame(fread(paste0(path,"Subset_3SNPs.G_Mat.GAPIT.SUPER.PH.GWAS.Results.csv")))

# FarmCPU
## IBDLD
IFarmCPU <- as.data.frame(fread(paste0(path,"Full_IBDLD.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

IFarmCPU_No2 <- as.data.frame(fread(paste0(path,"Subset_2SNPs_IBDLD.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

IFarmCPU_No5 <- as.data.frame(fread(paste0(path,"Subset_5SNPs_IBDLD.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

## G Matrix

GFarmCPU <- as.data.frame(fread(paste0(path,"Full_G_Mat.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

GFarmCPU_No2 <- as.data.frame(fread(paste0(path,"Subset_2SNPs_G_Mat.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

GFarmCPU_No5 <- as.data.frame(fread(paste0(path,"Subset_5SNPs_G_Mat.GAPIT.FarmCPU.PH.GWAS.Results.csv")))

# FaST-LMM
## IBDLD

FAST_IBDLD <- as.data.frame(fread(paste0(path,"PH_FaST_IBD.txt")))
colnames(FAST_IBDLD)[7] <- "FDR_Adjusted_P-values"


## G Matrix
FAST_GMA <- as.data.frame(fread(paste0(path,"PH_FaST_VanRaden.txt")))
colnames(FAST_GMA)[7] <- "FDR_Adjusted_P-values"


# CMLM
## IBDLD
CMLM <- as.data.frame(fread(paste0(path,"IBDLD.GAPIT.CMLM.PH.GWAS.Results.csv")))

## G Matrix

CMLM_GMAT <- as.data.frame(fread(paste0(path,"G_Mat.GAPIT.CMLM.PH.GWAS.Results.csv")))


# MMLM
## IBDLD
MMLM <- as.data.frame(fread(paste0(path,"IBDLD.GAPIT.MLMM.PH.GWAS.Results.csv")))

## G Matrix

MMLM_GMA <- as.data.frame(fread(paste0(path,"G_Mat.GAPIT.MLMM.PH.GWAS.Results.csv")))

########################

# Create the Data frames for each Model and Kinship
l <- sort(ls()[-grep("path",ls())])
for (i in 1:length(l)) {
  d <- get(l[i])
  d$`FDR_Adjusted_P-values` <- ifelse(d$`FDR_Adjusted_P-values` >=1, 0.999, d$`FDR_Adjusted_P-values`)
  d <- d %>% 
    group_by(Chromosome) %>% 
    summarise(chr_len=max(Position)) %>% 
    mutate(tot=cumsum(chr_len)-chr_len) %>%
    #select(-chr_len) %>%
    left_join(d, ., by=c("Chromosome"="Chromosome")) %>%
    arrange(Chromosome, Position) %>%
    mutate( BPcum=Position+tot)
  
 
  
  assign(paste0("don_",l[i]),
         d)
}

# Create the X axis label for each Manhattan plot
k <- ls()[grep("don",ls())]
for (i in 1:length(k)) {
  don <- get(k[i])
  df <- data.frame(Chromosome = rep(NA,10), Min = rep(NA,10),
                       Max = rep(NA,10), center = rep(NA,10))
  for (j in 1:10) {
    df[j,1] <-  j
    df[j,2] <-  min(subset(don, don$Chromosome == j)$BPcum)
    df[j,3] <- max(subset(don, don$Chromosome == j)$BPcum)
    df[j,4] <- ((df$Max[j]/1e06 + df$Min[j]/1e06)/2)*1e06
  }
  assign(paste0("axisdf",l[i]),
         df)
}

## Create the Manhattan plot
as <- ls()[grep("axisdf",ls())]
for (i in 1:length(k)) {
  don <- get(k[i])
  axisdf <- get(as[i])
    o <- ggplot(don, aes(x=BPcum,y= -log10(`FDR_Adjusted_P-values`))) +
    geom_point( aes(color=as.factor(Chromosome)), alpha=0.8, 
                size=2.3) +
    scale_color_manual(values = rep(c("#EC5f67", "#FAC863",
                                      '#99C794','#6699CC','#C594C5'),2 )) +
    scale_x_continuous( expand = c(0,0),label = axisdf$Chromosome, 
                        breaks= axisdf$center ) +
    scale_y_continuous(expand = c(0, 0), 
        limits = c(0,max(-log10(0.01),max(-log10(don$`FDR_Adjusted_P-values`))+0.1)) 
                       ) +    
    theme_bw() +
    theme( 
      legend.position="none",
      panel.grid = element_blank(),
      axis.title = element_text(size = 28, face = 'bold'),
      axis.text = element_text(size = 20, face = 'bold')
    ) + 
    geom_hline(yintercept = -log10(0.05), col = "darkgreen", 
               size = 1) +
    labs(x = "",
         y = expression(paste(-log[10]("FDR"), sep = "\n"))) +
    ggtitle(paste0("Manhattan Plot for ", k[i]))

  assign(paste0("Man_",k[i]), o)
  
}


# Save files as tiff
IM <- ls()[grep("Man_don", ls())]

for (i in 1:length(IM)) {
  file_name = paste(path,"Manhattan Plots/",IM[i], ".tiff", sep="")
  tiff(file_name, width = 1394, height = 720, units = "px")
  print(get(IM[i]))
  dev.off()
}


