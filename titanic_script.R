library(titanic)
library(tidyverse)
library(plyr)
library()
data(titanic_train)
titanic_train
titanic_train
titanic_train$Pclass
titanic_train$Sex
sum(is.na(titanic_train$Age))
titanic_test
titanic_train <- as.tbl(titanic_train)
by_sex <- group_by(titanic_train, Sex)
by_sex_sum <- dplyr::summarise(by_sex, 
                               number = n(),
                               num_survived = sum(Survived ==1),
                               percent_survived = num_survived/number
)
ggplot(by_sex_sum, aes(y = percent_survived, x= Sex))+
  geom_col(fill = "steelblue")
by_class <- group_by (titanic_train, Pclass)
by_class_sum <- dplyr::summarise(by_class,
                                 number= n(),
                                 num_survived = sum(Survived ==1), 
                                 percent_survived = num_survived/number)
by_class_sum
ggplot(by_class_sum, aes(y = percent_survived, x = Pclass))+
  geom_bar(stat = "identity", fill="steelblue")

titanic_train

by_age <- group_by(titanic_train, Age_group = cut(Age, 8))
by_age_sum <- dplyr::summarise(by_age,
                               number = n(),
                               num_survived = sum(Survived ==1), 
                               male =  sum(Sex == "male"),
                               male_survived= sum(Sex=="male"& Survived==1),
                               female =  sum(Sex == "female"),
                               female_survived= sum(Sex=="female"& Survived==1),
                               percent_survived = num_survived/number,
                               percent_survived_male = male_survived/male,
                               percent_survived_female = female_survived/female)
by_age_sum[,-c(2:3, 4,5,8)]
by_age_sum[,-c(2:7)]
by_age_Survived <- by_age[by_age$Survived == 1,]
by_age <- group_by(titanic_train, Parch)
ggplot(by_age, aes(x = Age_group)) +
  geom_bar(aes(fill = Sex),  position = "dodge")
ggplot(by_age, aes(x = Sex))+
  geom_bar(aes(fill = Age_group), position = "dodge")

ggplot(by_age, aes(x = Parch)) +
  geom_bar(aes(fill = Sex, linetype = factor(Survived, levels = c("1", "0"))), 
           color = "black", size = 1,position = "dodge")

ggplot(by_age_Survived, aes(x = Age_group)) +
  geom_bar(aes(fill = Sex), position = "dodge")

ggplot(by_age, aes(x = Age_group)) + 
  geom_bar(aes(fill = Sex, 
               linetype = factor(Survived, levels = c("1","0"))),
           color = "black", size = 1,position = "dodge")+
  guides(linetype = 
           guide_legend(title = "Survived", 
                        override.aes = list(fill = NA, col = "black")))


ggplot(by_age_Survived, aes(x = Sex)) +
  geom_bar(aes(fill = Age_group), position = "dodge")
ggplot(by_age_sum, aes(y = num_survived, x = Age_group))+
  geom_col(aes(fill = percent_survived_male), position = "dodge")


summary(titanic_train)
not_na_values <- titanic_train[!is.na(titanic_train$Age), ]
na_values <- titanic_train[is.na(titanic_train$Age), ]
summary(na_values)
summary(not_na_values)
table(na_values$Pclass)/nrow(na_values)
table(not_na_values$Pclass)/nrow(not_na_values)

survived_na_values <- titanic_train[is.na(titanic_train$Age)&titanic_train$Survived ==1,]
table(survived_na_values$Pclass)/table(na_values$Pclass)
survived_not_na_values <- titanic_train[!is.na(titanic_train$Age)&titanic_train$Survived==1,]
table(survived_not_na_values$Pclass)/table(not_na_values$Pclass)


by_sex_class <- group_by(titanic_train, Sex, Pclass)

by_sex_class_sum <- dplyr::summarise(
  by_sex_class,
  number = n(),
  average_age = mean(Age, na.rm= T)
)
by_sex_class_sum




na_values[na_values$Pclass==1& na_values$Sex == "female","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==1& by_sex_class_sum$Sex == "female","average_age"]
na_values[na_values$Pclass==2& na_values$Sex == "female","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==2& by_sex_class_sum$Sex == "female","average_age"]
na_values[na_values$Pclass==3& na_values$Sex == "female","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==3& by_sex_class_sum$Sex == "female","average_age"]
na_values[na_values$Pclass==1& na_values$Sex == "male","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==1& by_sex_class_sum$Sex == "male","average_age"]
na_values[na_values$Pclass==2& na_values$Sex == "male","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==2& by_sex_class_sum$Sex == "male","average_age"]
na_values[na_values$Pclass==3& na_values$Sex == "male","Age"] =
  by_sex_class_sum[by_sex_class_sum$Pclass==3& by_sex_class_sum$Sex == "male","average_age"]

na_values
by_sex_class_sum["Pclass"==3& "Sex" == "male",]
na_values
 filter(by_sex_class_sum, Pclass ==3 & Sex == "male")

by_sex_class
by_sex_class %>% mutate(Age = replace(Age, is.na(Age), mean(Age, na.rm = T)))
take_mean <- function(x){
  x[is.na(x)]= mean(x,na.rm)
}
by_sex_class %>% do(mean(by_sex_class$Age, na.rm = T))

replaced_na <- rbind(not_na_values, na_values)
replaced_na
write.csv(replaced_na, "titanic_na_replaced.csv")

not_na_values_test <- as.tbl(titanic_test[!is.na(titanic_test$Age), ])
na_values_test<- as.tbl(titanic_test[is.na(titanic_test$Age), ])
na_values_test
not_na_values_test


by_sex_class_test <- group_by(titanic_test, Sex, Pclass)

by_sex_class_sum_test <- dplyr::summarise(
  by_sex_class_test,
  number = n(),
  average_age = mean(Age, na.rm= T)
)
by_sex_class_sum_test


na_values_test[na_values_test$Pclass==1& na_values_test$Sex == "female","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==1& by_sex_class_sum_test$Sex == "female","average_age"]
na_values_test[na_values_test$Pclass==2& na_values_test$Sex == "female","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==2& by_sex_class_sum_test$Sex == "female","average_age"]
na_values_test[na_values_test$Pclass==3& na_values_test$Sex == "female","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==3& by_sex_class_sum_test$Sex == "female","average_age"]
na_values_test[na_values_test$Pclass==1& na_values_test$Sex == "male","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==1& by_sex_class_sum_test$Sex == "male","average_age"]
na_values_test[na_values_test$Pclass==2& na_values_test$Sex == "male","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==2& by_sex_class_sum_test$Sex == "male","average_age"]
na_values_test[na_values_test$Pclass==3& na_values_test$Sex == "male","Age"] =
  by_sex_class_sum_test[by_sex_class_sum_test$Pclass==3& by_sex_class_sum_test$Sex == "male","average_age"]
na_values_test

test_replaced_na <- rbind(not_na_values_test, na_values_test)
write.csv(test_replaced_na, "test_na_replaced.csv")
