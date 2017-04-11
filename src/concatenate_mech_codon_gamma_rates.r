library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)

file_names = c("r4s_norm_rates","r4s_orig_rates")
model = "mech_codon"
distr_dir = 'gamma_distr'

setwd("r4s_benchmark/")
for (name in file_names) {
  t1 <- list.files(paste0(model,"/r4s_rates/raw_rates/",distr_dir),pattern=name,full.names=T)
  info = file.info(t1)
  t1 <- t1[info$size != 0]
  
  for (i in 1:length(t1)) 
  {
    r1 <- read.table(t1[i],skip=11,sep="\t")
    #reformat rate4site output
    r <- r1 %>% separate(V1,into=c("c1","c2","c3","c4","c5","c6","c7","c8"),sep="\\][:blank:]*|[:blank:]*\\[[:blank:]*|\\,[:blank:]*|[:blank:]+",extra="drop") %>%
      separate(c8,into=c("c8","c9"),sep="\\/") %>% 
      select(-c(c1,c9))
    colnames(r) <- c("pos","seq","score","qq_int_lower","qq_int_upper","stdev","num_taxa")
    
    r$type <- rep("nobias",length(r$num_taxa))
    
    str <- regexpr("bl\\d+",t1[i])[1]
    end <- regexpr("_\\w+.txt",t1[i])[1]
    bl <- as.numeric(substr(t1[i],str+2,end-1))
    r$bl <- rep(bl,length(r$num_taxa))

    str <- regexpr("rep\\d+",t1[i])[1]
    end <- regexpr("_n\\d+",t1[i])[1]
    rep_num <- as.numeric(substr(t1[i],str+3,end-1))
    r$rep <- rep(rep_num,length(r$num_taxa))

    str <- regexpr("gamma\\d+",t1[i])[1]
    end <- regexpr(".txt",t1[i])[1]
    g_num <- as.numeric(substr(t1[i],str+5,end-1))
    r$gamma_distr <- rep(g_num,length(r$num_taxa))
    
    if (name=="r4s_norm_rates") {
      f_type="r4s_norm"
    } else {
      f_type="r4s_orig"
    }
    
    true_rates_file <- gsub(paste0("r4s_rates/raw_rates/gamma_distr/",name), 
                            "assigned_rates/processed_rates/sim_gamma_rates_combined", t1[i])
    true_r <- read.table(true_rates_file,header=T)
      
    ##get simulated dN/dS by solving for dN/dS
    true_r$dNdS <-  as.numeric(true_r$dN)/as.numeric(true_r$dS)
    r$true <-  true_r$dNdS
      
    if (i==1) {
      d <- r
    } else d <- rbind(d, r)
    
    }  
    write.csv(d,file=paste0(model,"/processed_rates/all_",name,"_gamma_nobias.csv"),quote=F)
  }