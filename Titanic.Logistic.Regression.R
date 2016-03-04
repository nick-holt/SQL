setwd("C:/Users/...")

library(readr)
train <- read_csv("train.csv", header = TRUE)
test <- read_csv("test.csv", header = TRUE)

str(train)
str(test)

mylog = glm(data = train, Survived ~ Pclass + Age + Sex, family = "binomial")

summary(glm(data = train, Survived ~ Pclass + Age + Sex, family = "binomial"))
# in this case I decide to keep all theree predictors in the model

# run the model on the training data itself
testprediction <- predict(mylog, type = "response")

# Make your prediction using the test set
my_prediction <- predict(mylog, test, type = "response")

# Create a data frame with two columns: PassengerId & Survived. Survived contains your predictions
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = my_prediction)

# Write your solution away to a csv file with the name my_solution.csv
write_csv(my_solution, file = "my_solution_LogReg.csv")