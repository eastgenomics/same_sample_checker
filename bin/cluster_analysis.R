# R
setwd("~/Documents/Projects/duty/EBH-1834")

mydir = "~/Documents/Projects/duty/EBH-1834"
total_files =  list.files(path = paste0(mydir), pattern= ("*pon_highdp_afs.txt"))

sample_names <- c()
AF_merged = as.data.frame(matrix(NA, ncol=2, nrow=0))
colnames(AF_merged) <- c("pos", "af")
for(i in 1:length(total_files)) { #up to 4 samples
  file <- total_files[i]
  file_name <- strsplit(file, "_pon_highdp_afs.txt") #removes the .tsv taken from file name
  tsv_file <- read.csv(paste(mydir, "/", file, sep= ""), sep="\t", header = F) #read in the file as a dataframe
  colnames(tsv_file) <- c("pos", file_name[[1]])
  if (i == 1){
    print("first file")
    AF_merged <- tsv_file
  } 
  AF_merged = merge(AF_merged,tsv_file,by="pos",all=FALSE)
  AF_merged = AF_merged[!duplicated(AF_merged$pos),]
  file_name <- file_name[[1]] #get the dataframe from the list
  sample_names <- c(sample_names, file_name)
  assign(file_name, tsv_file) #assigns the tsv_file to the object file_name which is the dataframe
  file_name <- NULL
  tsv_file <- NULL
}

dim(AF_merged)
rownames(AF_merged)=AF_merged$pos
AF_merged=AF_merged[,-1]
mydata <- t(AF_merged)
z <- mydata[,-c(1,4)]
means <- apply(z,2,mean)
sds <- apply(z,2,sd)
nor <- scale(z,center=means,scale=sds)
distance <- dist(t(AF_merged))
mydata.hclust <- hclust(distance)
pdf("cluster_analysis_EBH-1834.pdf")
plot(mydata.hclust, main = "Clustering of Samples by Germline AFs")
dev.off()
