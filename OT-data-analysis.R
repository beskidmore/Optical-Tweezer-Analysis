
library("ggplot2")
library(reshape)
library('coin')
library('fields')
library('plyr')

setwd("C:/Users/skidmore/Desktop/OT_data")


otdata = read.csv('Full-spectrum-compiled-results-reduced2.csv',na.strings=c("", "NA"), header = TRUE)

ggplot(otdata, aes(Weight)) + geom_histogram()

names(otdata)
melot = melt(otdata, id=c('Weight','Result'))
melot2 = na.omit(melt(otdata, id=c('Cellidentifier', 'Result', 'Weight')))
ggplot(melot, aes(Weight, Result, color = Result)) + geom_point()


ggplot(melot2, aes(Cellidentifier, Result, color = Weight)) + geom_point() + scale_color_gradient(low = "blue", high = "red")


#Weight by rainbow
ggplot(melot2, aes(Cellidentifier, Result, color = Weight)) + 
  geom_point() +
  scale_color_gradientn(colors = rainbow(5)) +
  theme(axis.text.x = element_text(angle = 90))

#Result by weight histogram
ggplot(melot2, aes(Result, Weight)) + 
  geom_boxplot() 

##clustering of mean plateau forces
forceweight <- data.frame(otdata$Weight, otdata$mean.plateau.force)
fw = na.omit(forceweight)
mydata <- scale(fw$otdata.mean.plateau.force)
# Determine number of clusters
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(mydata,
                                     centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

# K-Means Cluster Analysis
fit <- kmeans(mydata, 3) # 3 cluster solution
# get cluster means
aggregate(mydata,by=list(fit$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(mydata, fit$cluster)
library(cluster)
#plot kmeans cluster
clusplot(mydata, fit$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)


#clustering without scaled numbers
fit2 <- kmeans(fw$otdata.mean.plateau.force, 3)
aggregate(fw$otdata.mean.plateau.force,by=list(fit$cluster),FUN=mean)
mydata2 <- data.frame(fw$otdata.mean.plateau.force, fit$cluster)
clusplot(mydata2, fit$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)

ggplot(mydata2, aes(fw$otdata.mean.plateau.force, fit.cluster = 1 ))

##plot(fw$otdata.mean.plateau.force, fw$otdata.mean.plateau.force)




#This section examins the mean force of plateau by weight of animal.No real connection
forceweight <- data.frame(otdata$Weight, otdata$mean.plateau.force)
fw = na.omit(forceweight)
names(fw)
#weight vs mean plateau force points
ggplot(fw, aes(otdata.Weight, otdata.mean.plateau.force)) + geom_point()
#weight vs mean plateau force box
ggplot(fw, aes(otdata.Weight, otdata.mean.plateau.force)) + 
  geom_boxplot(aes(factor(otdata.Weight), otdata.mean.plateau.force))
#weight vs mean plateau force box bins
fw$bin <- cut(fw$otdata.Weight, c(300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900))
ggplot(fw, aes(otdata.Weight, otdata.mean.plateau.force)) + geom_boxplot(aes(bin, otdata.mean.plateau.force))

ddply(fw, .(cut(fw$otdata.Weight, 6)), colwise(mean))

##stats.bin(x =fw$otdata.mean.plateau.force, y =fw$otdata.Weight, breaks= seq(350,900,,50))


mean(fw$otdata.mean.plateau.force)

length(which(fw$otdata.Weight <= '440'))

result.aov = aov(Weight~as.factor(Result),otdata)
summary(result.aov)




length(which(otdata$Result == 'Plateau'))














#By rainbow after NO AOD is used
ggplot(melot2, aes(Cellidentifier, Result, color = Weight)) + 
  geom_point(data=subset(melot2, Cellidentifier>="2138")) +
  scale_color_gradientn(colors = rainbow(5)) +
  theme(axis.text.x = element_text(angle = 90))

mean(otdata$Weight)
std <- function(x) sd(x)/sqrt(length(x))
sd(otdata$Weight)

 theme(legend.position = "none")

