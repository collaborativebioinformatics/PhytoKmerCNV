#!/usr/bin/env Rscript
# fit lm to check corr
# cjfiscus
# 2023-10-04

library(pacman)
p_load(ggplot2, cowplot, ggpubr)

# set this to your wd
setwd("~/Desktop")

# dataset
df<-read.delim("testdata_ftp.txt")

# ests produced by our pl
df1<-read.table("output.txt")
names(df1)<-c("run_accession", "total", "nbs")
df1$prop<-df1$nbs/df1$total

df<-merge(df1, df, by="run_accession")

# annot-based ests
annot<-read.table("nbarc_counts.txt")
names(annot)<-c("sample", "count")

## match sample names
df$sample<-gsub("_", "",df$sample_alias)
df$sample<-gsub("Heinz1706", "SL5", df$sample)

## merge all samples
m<-merge(df, annot, by="sample")

## fit lm
p1<-ggplot(m, aes(x=prop, y=count)) + 
  geom_point() + geom_smooth(method="lm") +
  xlab("prop. of 21-mer abund. in captured reads") +
  ylab("freq. NBS-LRR genes") +
  stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~"))) +
  theme_cowplot()
ggsave("~/Desktop/result.pdf", p1, height=4, width=4)
