#####calculate pi value: for example (CES VS ET, ET is the Interested population)
ES <- read.table("./CES.windowed.pi",header=T)
ET <- read.table("./ET.windowed.pi",header=T)
N <- read.table("./N.windowed.pi",header=T)
S <- read.table("./S.windowed.pi",header=T)
WS <- read.table("./WS.windowed.pi",header=T)

chrom<-c()
start<-c()
end<-c()
ES_pi<-c()
ET_pi<-c()
N_pi<-c()
S_pi<-c()
WS_pi<-c()
ratio<-c()
all.pi <- data.frame()

for (chr in c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18")){
  ES1 <- ES[ES$CHROM==chr,]
  ET1 <- ET[ET$CHROM==chr,]
  N1 <- N[N$CHROM==chr,]
  S1 <- S[S$CHROM==chr,]
  WS1 <- WS[WS$CHROM==chr,]
  
  ESpi <- ES1$BIN_START
  ETpi <- ET1$BIN_START
  Npi <- N1$BIN_START
  Spi <- S1$BIN_START
  WSpi <- WS1$BIN_START
  
  
  for (d in ESpi){
    for (b in ETpi){
      if (d==b ){
        rat=ES1[ES1$BIN_START==d,]$PI/ET1[ET1$BIN_START==d,]$PI
        ratio=log(rat,2)
        chrom=chr
        start=b
        end=ET1[ET1$BIN_START==b,]$BIN_END
        ES_pi=ES1[ES1$BIN_START==d,]$PI
        ET_pi=ET1[ET1$BIN_START==d,]$PI
        add<-data.frame(chrom,start,end,ES_pi,ET_pi,ratio)
        all.pi<-rbind(all.pi, add)
      }
    }
  }
}

write.table(all.pi,"./CES_ET.txt",quote = F,row.names = F)




#####select top 5%
library("dplyr")
library("tidyr")


du<-read.table("./CES_ET.txt",header = T)%>%
  filter(!is.na(ratio)) %>%
  unite("id", chrom, end,sep="_",remove=FALSE) %>%
  select(id, ratio)


######CES VS ET, ET is the Interested population
quant_du_5<-du[order(du$ratio),] 
nrow<-nrow(quant_du_5)*0.95
threshold<-quant_du_5[nrow,2]   

win<-du[du$ratio>threshold,]

write.table(win,"./CES_vs_ET_5%.txt",quote = F,row.names = F)


