#Installation----
set.seed(15)
install.packages("tidyverse") #run this is you needed to install R again
install.packages("fastDummies") #for one hot encoding
install.packages("cluster") #clustering and cluster visualization
install.packages("factoextra") #for visualization
install.packages("plotly") #interactive plot
install.packages("pheatmap") #heat-map
install.packages('igraph') #for fviz_dent
install.packages('mclust') #for statistical model
install.packages("dbscan") #dbscan
install.packages('caret')
install.packages('party')


library("ggplot2")
library("dplyr") #for data manipulation
library("fastDummies")
library("cluster")
library("factoextra")
library("plotly")
library("pheatmap")
library("igraph")
library("mclust")
library("dbscan")
library(caret)
library(party)


main_data<-read.csv("adult.csv")
colnames(main_data)

#Preprocessing----

main_data <- main_data %>%
  rename(
    age = X39,
    workclass = State.gov,
    fnlwgt = X77516,
    education = Bachelors,
    education_num = X13,
    marital_status = Never.married,
    occupation = Adm.clerical,
    relationship = Not.in.family,
    race = White,
    sex = Male,
    capital_gain = X2174,
    capital_loss = X0,
    hours_per_week = X40,
    native_country = United.States,
    income = X..50K,
  )

#removing null values
main_data[main_data==""]<-NA #change "" to NA
main_data<-main_data[complete.cases(main_data), ] # remove NAs

#Seperate numeric and categorical
data<-main_data %>% select_if(is.numeric)
data<- data [, -(4:5)]
categorical<-main_data %>% select_if(is.character)
categorical <- categorical[,-8] #Removed United.State column as it had too many unique values and did not provide useful information
#View(data)
#View(categorical)

one_hot_encoded<-dummy_cols(categorical,remove_first_dummy = TRUE)
#View(one_hot_encoded)

one_hot_encoded<-one_hot_encoded[,9:62] #ignore original columns that are still categorical
#View(one_hot_encoded)

data<-cbind(data,one_hot_encoded) # Merge dataset
View(data)

#Scaling/Normalization----
data<-scale(data[,])
?n
#extracting best features
#use it like this when clustering:
#kmeans(data[,selected_features], centers=3)
selected_features<-nearZeroVar(data)
class(selected_features)
selected_features

# calculate correlation matrix
correlationMatrix <- cor(data)
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)
# print indexes of highly correlated attributes
print(highlyCorrelated)

#KMeans Clustering----

kmeans_data <- data[ , c(5, 7, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 25, 26, 28, 30, 32, 33, 35, 38, 39, 42, 44, 46, 47, 49, 52, 53, 55)]
fit_km6<-kmeans(kmeans_data,3) #just random cluster number
#fit_km6
clusters<-fit_km6$cluster
centers<-fit_km6$centers
kg<-fviz_cluster(fit_km6, kmeans_data, ellipse.type = "norm")
ggplotly(kg)
write.csv(centers,"adult_clusters_selected.csv")


kmeans_data2<- data[ , c( 3,29,31,56)]
fit_km6<-kmeans(kmeans_data2,3) #just random cluster number
#fit_km6
clusters<-fit_km6$cluster
centers<-fit_km6$centers
kg<-fviz_cluster(fit_km6, kmeans_data2, ellipse.type = "norm")
ggplotly(kg)
write.csv(centers,"adult_clusters_corr.csv")


kmeans_data3<- data[ , c(1, 3, 4, 31, 56,57 , 58)] # Best
fit_km6<-kmeans(kmeans_data3,3) #just random cluster number
#fit_km6
clusters<-fit_km6$cluster
centers<-fit_km6$centers
kg<-fviz_cluster(fit_km6, kmeans_data3, ellipse.type = "norm")
ggplotly(kg)
write.csv(centers,"adult_clusters_random3.csv")

clusters<-paste("clusters",clusters)
sub_data_cluster<-cbind(kmeans_data3,clusters)
graph<-ggplot(sub_data_cluster,(aes(age,"income_ >50K")))+
  geom_point(aes(fill=clusters),
             shape=21,
             alpha=0.3,
             size=5)+
  labs(title = 'Cluster destribution: age vs income_ >50K ')
ggplotly(graph)

#---- Age & Income Subclusters
fviz_cluster(fit_km6, kmeans_data3[,c(1,7)], ellipse.type = "norm")

#---- Married & Income Subclusters
fviz_cluster(fit_km6, kmeans_data3[,c(4,7)], ellipse.type = "norm")


#Kmeans Evaluation

plot(as.data.frame(kmeans_data3))

# Sum of squares
sum_of_square<-fit_km6$betweenss / fit_km6$totss
sum_of_square

# Silhouette Method
sihouette<-silhouette(clusters,dist(kmeans_data3))
View(sihouette)

fviz_silhouette(sihouette,
                main='Silhouette plot',
                palette = "jco" #colour palette
)


#Different value of k for Best

fit_km6<-kmeans(kmeans_data3,4) #just random cluster number
#fit_km6
clusters<-fit_km6$cluster
centers<-fit_km6$centers
kg<-fviz_cluster(fit_km6, kmeans_data3, ellipse.type = "norm")
ggplotly(kg)


#Hierachial CLustering----
my_sample <- sample(kmeans_data3, 50, replace = FALSE, prob = NULL)

#HCLUST Model
fit_hc<-hclust(dist(my_sample),"ward.D2")
hc_clusters<-cutree(fit_hc,3)
hc_clusters
plot(fit_hc)
rect.hclust(fit_hc,k=3,border="red")

fviz_dend(as.dendrogram(fit_hc),k=3, cex=0.8)

fviz_dend(as.dendrogram(fit_hc),k=3, cex=0.8,
          type="phylogenic",
          phylo_layout="layout_as_tree")


#Closer look into the cluster
View(kmeans_data3[c(7, 24, 32, 28, 5, 17, 16, 18, 6, 3, 30, 32, 1, 39),])
View(kmeans_data3[c(9, 10, 35, 36, 41, 33, 31, 20, 4 ,19, 43, 40, 21),])
View(kmeans_data3[c(50, 25, 29),])


#MultiLeveling Clustering ----
multi_matrix <- data.matrix(kmeans_data3[c(9, 10, 35, 36, 41, 33, 31, 26, 20, 4 ,19, 47, 12, 46, 48, 43, 40,34, 15, 21),])
fit_km6<-kmeans(multi_matrix,3)
clusters<-fit_km6$cluster
centers<-fit_km6$centers
kg<-fviz_cluster(fit_km6, multi_matrix, ellipse.type = "norm")
ggplotly(kg)
write.csv(centers,"adult_clusters_multi.csv")

