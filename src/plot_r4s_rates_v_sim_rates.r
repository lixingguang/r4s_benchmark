library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)

t_bias <- read.csv("other_methods_results/all_methods_processed_rates/all_methods_bias.csv",row.names=1)
t_nobias <- read.csv("other_methods_results/all_methods_processed_rates/all_methods_nobias.csv",row.names=1)

r_bias <- t_bias %>% filter(method=="Rate4Site")
r_nobias <- t_nobias %>% filter(method=="Rate4Site")

# p1 <- ggplot(a,aes(dN,r4s_score)) + 
#   geom_point(size=1,alpha=0.7) + 
#   geom_smooth(method=lm) +
#   xlab(expression(bold("predicted rate (dN/dS)"))) +
#   ylab("rate4site score") +
#   theme(axis.text=element_text(size=8),legend.position="none") +
#   geom_text(aes(x=0.3,y=5,label=paste0(round(cor,2),sig),size=4)) +
#   scale_x_continuous(breaks=seq(0,1,0.5), labels=c("0","0.5","1.0"), limits = c(0.0,1.0)) + 
#   scale_y_continuous(breaks=seq(-2,6,2), limits = c(-2,6)) +
#   facet_grid(num_taxa ~ branch_len) +
#   background_grid(major = 'xy', minor = "none") + 
#   panel_border()
# ggsave(paste0("plots/",model,"_r4s_rates_v_sim_rates.png"))

##Plot Bias data
colfunc <- colorRampPalette(c("orange","darkred"))
p2 <- ggplot(r_bias,aes(ntaxa,cor1,color=factor(bl),group=bl)) + 
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x), 
               fun.ymax = function(x) mean(x) + sd(x), 
               geom = "pointrange",
               size=0.8) +
  scale_colour_manual(values=colfunc(5)) +
  guides(col = guide_legend(title="Branch Length",reverse = TRUE)) +
  stat_summary(fun.y = mean,geom = "line",size=0.8,aes(color=factor(bl)))+
  xlab("Number of Taxa") +
  ylab("Correlation (spearman)") +
	scale_y_continuous(breaks=seq(0,1,0.2), limits = c(0,1)) +
  scale_x_log10(breaks=c(128,256,512,1024,2048)) +
  theme(axis.title = element_text(size = 18),
        axis.text = element_text(size = 17),
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16))
ggsave(paste0("plots/mut_sel_dN_dS_cor_v_num_taxa.png"))

colfunc <- colorRampPalette(c("cyan2","navyblue"))
p3 <- ggplot(r_bias,aes(bl,cor1,colour=factor(ntaxa),group=ntaxa)) + 
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x), 
               fun.ymax = function(x) mean(x) + sd(x), 
               geom = "pointrange",
               size=0.8) +
  scale_x_log10(breaks=c(0.0025,0.01,0.04,0.16,0.64)) +
  scale_colour_manual(values=colfunc(5)) +
  guides(col = guide_legend(title="Number of Taxa",reverse = TRUE)) +
  stat_summary(fun.y = mean,geom = "line",size=0.8,aes(color=factor(ntaxa)))+
  xlab("Branch Length") +
  ylab("Correlation (spearman)") +
  scale_y_continuous(breaks=seq(0,1,0.2), limits = c(0,1))+ 
  theme(axis.title = element_text(size = 18),
        axis.text = element_text(size = 17),
        legend.text = element_text(size = 16),
        legend.title = element_text(size = 16))
ggsave(paste0("plots/mut_sel_dN_cor_v_branch_len.png"))



