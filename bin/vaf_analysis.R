# R
## packages
library(ggplot2)
library("ggpubr")
library(grid)


### create a df of shared sites
mydir = "~/Documents/Projects/duty/EBH-1834"
total_files =  list.files(path = paste0(mydir), pattern= ("*pon_highdp_afs.txt"))

#Read multiple files from each chr
sample_names <- c()
for(i in 1:length(total_files)) { #up to 4 samples
  file <- total_files[i]
  file_name <- strsplit(file, "_pon_highdp_afs.txt") #removes the .tsv taken from file name
  tsv_file <- read.csv(paste(mydir, "/", file, sep= ""), sep="\t", header = F) #read in the file as a dataframe
  file_name <- file_name[[1]] #get the dataframe from the list
  sample_names <- c(sample_names, file_name)
  assign(file_name, tsv_file) #assigns the tsv_file to the object file_name which is the dataframe
  file_name <- NULL
  tsv_file <- NULL
}


corr_calc <- function(df_1, df_2){
  df <- merge(x =df_1, y = df_2, by = "V1", all = TRUE)
  df2 <- df[complete.cases(df), ]
  df2 <- df2[!duplicated(df2), ]
  cor_value <- round(cor(df2[,2], df2[,3]),4)
  return(cor_value)
}

mega_correlation <- as.data.frame(matrix(NA, nrow = length(sample_names), ncol = length(sample_names)))
rownames(mega_correlation) <- sample_names
colnames(mega_correlation) <- sample_names

pdf("corr_plots.pdf")
for(row in 1:nrow(mega_correlation)) {
  for(col in 1:ncol(mega_correlation)) {
    mega_correlation[row,col] <- corr_calc(get(sample_names[row]), get(sample_names[col]))
    df <- merge(x =get(sample_names[row]), y = get(sample_names[col]), by = "V1", all = TRUE)
    df2 <- df[complete.cases(df), ]
    df2 <- df2[!duplicated(df2), ]
    grob1 <- grobTree(textGrob(paste("Pearson Corr: ", round(cor(df2[, 2], df2[, 3]), 4) ), x = 0.63, y = 0.97, hjust = 0, gp = gpar(col = "red", fontsize = 11, fontface = "bold")))
    p <- ggplot(df2, aes(x = df2[, 2], y = df2[, 3])) +
      geom_point() +
      geom_smooth() +
      geom_abline() +
      annotation_custom(grob1) +
      theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA)
      ) +
      labs(x = sample_names[row], y = sample_names[col])
    print(p)
  }
}
dev.off()

write.table(mega_correlation, "PearsonCorrelation_PoN_AFs.tsv",
            sep = "\t",  quote = F )
