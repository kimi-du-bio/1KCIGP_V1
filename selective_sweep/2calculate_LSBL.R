##calculate LSBL, z transform, and select top 5% window (For example: CES VS ET)

###remove chromosome X, chromosome Y and mitochondrion
library(dplyr)
library(tidyr)
CESET<-
  read.table("./CES_vs_ET_fst.windowed.weir.fst",header=T) %>%
  filter(!is.na(WEIGHTED_FST)) %>%   
  filter(CHROM != "chrX" ) %>%   
  filter(CHROM != "chrY" ) %>%  
  filter(CHROM != "MT" ) %>%
  unite("id", CHROM, BIN_END,sep="_",remove=FALSE) %>%    
  select(id, CHROM, BIN_START,BIN_END, WEIGHTED_FST)

write.table(CESET,"./CES_vs_ET.txt",quote = F,row.names = F)

ETEUD<-
  read.table("./ET_vs_EUD_fst.windowed.weir.fst",header=T) %>%
  filter(!is.na(WEIGHTED_FST)) %>%   
  filter(CHROM != "chrX" ) %>%   
  filter(CHROM != "chrY" ) %>%  
  filter(CHROM != "MT" ) %>%
  unite("id", CHROM, BIN_END,sep="_",remove=FALSE) %>%    
  select(id, CHROM, BIN_START,BIN_END, WEIGHTED_FST)

write.table(ETEUD,"./ET_vs_EUD.txt",quote = F,row.names = F)

CESEUD<-
  read.table("./CES_vs_EUD_fst.windowed.weir.fst",header=T) %>%
  filter(!is.na(WEIGHTED_FST)) %>%   
  filter(CHROM != "chrX" ) %>%   
  filter(CHROM != "chrY" ) %>%  
  filter(CHROM != "MT" ) %>%
  unite("id", CHROM, BIN_END,sep="_",remove=FALSE) %>%    
  select(id, CHROM, BIN_START,BIN_END, WEIGHTED_FST)

write.table(CESEUD,"./CES_vs_EUD.txt",quote = F,row.names = F)


###calculate LSBL and keep top 5% (CES VS ET, CES is the Interested population)
data1<-read.table("./CES_vs_ET.txt",header=T)
data2<-read.table("./CES_vs_EUD.txt",header=T)
data3<-read.table("./ET_vs_EUD.txt",header=T)
id<-intersect(data1$id,data2$id)
id<-intersect(id,data3$id)
id<-as.data.frame(id)
result<-data.frame()

for (i in 1:nrow(id))
{
  name<-id[i,1]
  LSBL=data1[data1$id==name,]$WEIGHTED_FST+data2[data2$id==name,]$WEIGHTED_FST-data3[data3$id==name,]$WEIGHTED_FST
  LSBL=LSBL/2
  add<-data.frame(name,LSBL)
  result<-rbind(result, add)
}

# z transform
mean_value <- mean(result$LSBL)
sd_value <- sd(result$LSBL)
result$z <- (result$LSBL - mean_value) / sd_value


result<-result[order(result$z),]
nrow<-nrow(df)*0.05
threshold<-result[nrow,2]  

result5<-result[result$z>threshold,]

write.table(result5,"./CESmain_vs_ET.txt",quote = F,row.names = F)




###calculate LSBL (CES VS ET, ET is the Interested population)
data1<-read.table("./CES_vs_ET.txt",header=T)
data2<-read.table("./ET_vs_EUD.txt",header=T)
data3<-read.table("./CES_vs_EUD.txt",header=T)
id<-intersect(data1$id,data2$id)
id<-intersect(id,data3$id)
id<-as.data.frame(id)
result<-data.frame()

for (i in 1:nrow(id))
{
  name<-id[i,1]
  LSBL=data1[data1$id==name,]$WEIGHTED_FST+data2[data2$id==name,]$WEIGHTED_FST-data3[data3$id==name,]$WEIGHTED_FST
  LSBL=LSBL/2
  add<-data.frame(name,LSBL)
  result<-rbind(result, add)
}

#z transform
mean_value <- mean(result$LSBL)
sd_value <- sd(result$LSBL)
result$z <- (result$LSBL - mean_value) / sd_value

result<-result[order(result$z),]
nrow<-nrow(df)*0.95  
threshold<-result[nrow,2]   
result5<-result[result$z>threshold,]

write.table(result5,"./CES_vs_ETmain.txt",quote = F,row.names = F)