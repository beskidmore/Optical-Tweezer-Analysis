library("ggplot2")
library(reshape)
library('coin')
library('fields')
library('plyr')


getwd()
setwd('C:/Users/skidmore/Desktop/OT_data/')

dataf = read.csv('xt-voltage-all.csv',na.strings=c("", "NA"), header = TRUE)
names(dataf)

require(reshape2)
ggplot(data = melt(dataf), aes(x=variable, y=value)) + geom_boxplot(aes(fill=variable)) + 
  ggtitle('Ben v. Vivek Xt_voltage') +
  xlab("Details") + ylab("Xt_voltage") +theme(axis.text.x = element_text(angle = 90))
  
