---
title: "Marketing_Proj"
author: '1'
date: "4/17/2021"
output: html_document
---
```{r}
rm(list = ls())
library(cvms)
library(broom)    # tidy()
library(tibble) 


setwd("C:/Users/mshch96/Desktop/Mrk_Final_Project_5_12") # set the wd

DataFile = "ChurnData.csv"
ChurnData = read.csv(DataFile, header=T)

# Convert No to 0 and Yes to 1
ChurnData$Partner = as.numeric(as.factor(ChurnData$Partner)) - 1
ChurnData$Dependents = as.numeric(as.factor(ChurnData$Dependents)) - 1
ChurnData$PhoneService = as.numeric(as.factor(ChurnData$PhoneService)) - 1
ChurnData$MultipleLines = as.numeric(as.factor(ChurnData$MultipleLines)) - 1
ChurnData$OnlineSecurity = as.numeric(as.factor(ChurnData$OnlineSecurity)) - 1
ChurnData$OnlineBackup = as.numeric(as.factor(ChurnData$OnlineBackup)) - 1
ChurnData$DeviceProtection = as.numeric(as.factor(ChurnData$DeviceProtection)) - 1
ChurnData$TechSupport = as.numeric(as.factor(ChurnData$TechSupport)) - 1
ChurnData$StreamingTV = as.numeric(as.factor(ChurnData$StreamingTV)) - 1
ChurnData$StreamingMovies = as.numeric(as.factor(ChurnData$StreamingMovies)) - 1
ChurnData$PaperlessBilling = as.numeric(as.factor(ChurnData$PaperlessBilling)) - 1
ChurnData$Churn = as.numeric(as.factor(ChurnData$Churn)) - 1

# Female = 0, Male = 1
ChurnData$gender = as.numeric(as.factor(ChurnData$gender)) - 1

# InternetService/Contract/paymentmethod  into factor 
ChurnData$InternetService = as.factor(ChurnData$InternetService)
ChurnData$Contract = as.factor(ChurnData$Contract)
ChurnData$PaymentMethod = as.factor(ChurnData$PaymentMethod)

# delete NA
ChurnData = ChurnData[complete.cases(ChurnData), ]

ChurnData

```


# General Model Exploration 
```{r}

ChurnData.lm = lm(Churn~gender+SeniorCitizen+Partner+Dependents+tenure+PhoneService+MultipleLines+InternetService + OnlineSecurity + OnlineBackup + DeviceProtection + TechSupport + StreamingTV + StreamingMovies + Contract + PaperlessBilling + PaymentMethod	+ MonthlyCharges+TotalCharges, 	data = ChurnData)

ChurnData.glm1 = glm(Churn~gender+SeniorCitizen+Partner+Dependents+tenure+PhoneService+MultipleLines+InternetService + OnlineSecurity + OnlineBackup + DeviceProtection + TechSupport + StreamingTV + StreamingMovies + Contract + PaperlessBilling + PaymentMethod	+ MonthlyCharges+TotalCharges, 	data = ChurnData,family=binomial(link="logit"))

ChurnData.glm2 = glm(Churn~gender+SeniorCitizen+Partner+Dependents+tenure+PhoneService+MultipleLines+InternetService + OnlineSecurity + OnlineBackup + DeviceProtection + TechSupport + StreamingTV + StreamingMovies + Contract + PaperlessBilling + PaymentMethod	+ MonthlyCharges+TotalCharges, 	data = ChurnData,family=binomial(link="probit"))

summary(ChurnData.lm)
summary(ChurnData.glm1)
summary(ChurnData.glm2)

```

# General Model Performance
```{r}
AIC(ChurnData.lm)
AIC(ChurnData.glm1)
AIC(ChurnData.glm2)


BIC(ChurnData.lm)
BIC(ChurnData.glm1)
BIC(ChurnData.glm2)
```

# Split test and train 
```{r}
# 70% train, 30% test 
dt = sort(sample(nrow(ChurnData),nrow(ChurnData)*0.7))
train = ChurnData[dt,]
test = ChurnData[-dt,]
nrow(train)
nrow(test)

```

# fit model 
```{r}
ChurnData.glm1 = glm(Churn~gender+SeniorCitizen+Partner+Dependents+tenure+PhoneService+MultipleLines+InternetService + OnlineSecurity + OnlineBackup + DeviceProtection + TechSupport + StreamingTV + StreamingMovies + Contract + PaperlessBilling + PaymentMethod	+ MonthlyCharges+TotalCharges, 	data = train,family=binomial(link="logit"))

ChurnData.glm2 = glm(Churn~gender+SeniorCitizen+Partner+Dependents+tenure+PhoneService+MultipleLines+InternetService + OnlineSecurity + OnlineBackup + DeviceProtection + TechSupport + StreamingTV + StreamingMovies + Contract + PaperlessBilling + PaymentMethod	+ MonthlyCharges+TotalCharges, 	data = train,family=binomial(link="probit"))

```


# Accuracy 
```{r}
glm1.prediction = predict(ChurnData.glm1, test)
glm1.prediction = ifelse(glm1.prediction > 0,1,0)
glm2.prediction = predict(ChurnData.glm2, test)
glm2.prediction = ifelse(glm2.prediction > 0,1,0)

glm1.prediction = matrix(glm1.prediction)
glm2.prediction = matrix(glm2.prediction)
truth = matrix(test$Churn)

# for glm1
glm1.d_binomial <- tibble("target" = truth,"prediction" = glm1.prediction)
glm1.basic_table <- table(glm1.d_binomial)

# for glm2 
glm2.d_binomial <- tibble("target" = truth,"prediction" = glm2.prediction)
glm2.basic_table <- table(glm2.d_binomial)


glm1.accuracy = (glm1.basic_table[1,1] + glm1.basic_table[2,2])/sum(glm1.basic_table)
glm2.accuracy = (glm2.basic_table[1,1] + glm2.basic_table[2,2])/sum(glm2.basic_table)


cat(glm1.accuracy,glm2.accuracy)
```

glm1 has higher accuracy. Coherent with AIC, BIC result. 

# Accuracy Evaluate glm1 
```{r}
# Accuracy 
library(ROCR) 
library(Metrics)

# AUC curve
pr <- prediction(glm1.prediction,test$Churn)
perf <- performance(pr,measure = "tpr",x.measure = "fpr") 
plot(perf) > auc(test$Churn,glm1.prediction) 

# Confusion Matrix with plot 


d_binomial <- tibble("target" = truth,"prediction" = glm1.prediction)
basic_table <- table(d_binomial)
cfm <- tidy(basic_table)

plot_confusion_matrix(cfm, 
                      target_col = "target", 
                      prediction_col = "prediction",
                      counts_col = "n")
```

In the middle of each tile, we have the normalized count (overall percentage) and, beneath it, the count.

At the bottom, we have the column percentage. Of all the observations where Target is 1, 34.7% of them were predicted to be 1 and 65.3% 0.

At the right side of each tile, we have the row percentage. Of all the observations where Prediction is 1, 4.1% of them were actually 1, while 95.9% were 0.

Note that the color intensity is based on the counts.

```{r}

```


# Random forest
```{r}
library(randomForest)
rf_train= train
rf_test = test 
rf_train$Churn = as.factor(rf_train$Churn)
rf_test$Churn = as.factor(rf_test$Churn)

rf <- randomForest(Churn ~ .,data=rf_train,importance = TRUE,ntree = 1000)
rf.prediction = predict(rf, rf_test)

# for rf 
rf.d_binomial <- tibble("target" = truth,"prediction" = rf.prediction)
rf.basic_table <- table(rf.d_binomial)


rf.accuracy = (rf.basic_table[1,1] + rf.basic_table[2,2])/sum(rf.basic_table)
rf.accuracy
```

```{r}

varImpPlot(rf)

importance(rf)

# error 
plot(rf)



# plot a sample tree
library("party")
x <- ctree(Churn ~ ., data=rf_train)
plot(x, type="simple")
```


1. Mean Decrease Accuracy - how much the model accuracy decreases if we drop that variable
2. Mean Decrease Gini- measure of variable improtance bansed on ghe Gini Impurity index used for the calculation of splits in tree

```{r}
pred1 = predict(rf, type = "prob")
library(ROCR)
perf = prediction(pred1[,2], train$Churn)

# Area under curve
auc = performance(perf, "auc")
auc

# True Positive and nEgative Rate 
pred3 = performance(perf,"tpr","fpr")

# plot
plot(pred3,main = "ROC CURVE FOR RANDOM FOREST", col = 2, lwd = 2)
abline(a=0,b=1,lwd=2,lty=2,col="gray")



```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```

```{r}

```
