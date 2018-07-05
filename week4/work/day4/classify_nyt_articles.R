library(tidyverse)
library(tm)
library(Matrix)
library(glmnet)
library(ROCR)
library(broom)
########################################
# LOAD AND PARSE ARTICLES
########################################

# read in the business and world articles from files
# combine them both into one data frame called articles
articles <- read_tsv('data.tsv',quote="")
articles$section <- factor(articles$section)
# create a corpus from the article snippets
# using the Corpus and VectorSource functions
corpus <- Corpus(VectorSource(articles$snippet))

# create a DocumentTermMatrix from the snippet Corpus
# remove stopwords, punctuation, and numbers
dtm <- DocumentTermMatrix(corpus, list(weighting=weightBin,
                                       stopwords=T,
                                       removePunctuation=T,
                                       removeNumbers=T))

# convert the DocumentTermMatrix to a sparseMatrix
X <- sparseMatrix(i=dtm$i, j=dtm$j, x=dtm$v, dims=c(dtm$nrow, dtm$ncol), dimnames=dtm$dimnames)

# set a seed for the random number generator so we all agree
set.seed(42)

########################################
# YOUR SOLUTION BELOW
########################################

# create a train / test split
testRatio <- .2
rowCount <- nrow(articles)
testIndices <- sample(rowCount, testRatio * rowCount)

test <- X[testIndices,]
test_section <- articles$section[testIndices]
train <- X[-testIndices,]
train_section <-articles$section[-testIndices]

# cross-validate logistic regression with cv.glmnet (family="binomial"), measuring auc
model <- cv.glmnet(train,train_section,family = "binomial")

# plot the cross-validation curve
plot(model)
# evaluate performance for the best-fit model
# note: it's useful to explicitly cast glmnet's predictions
# use as.numeric for probabilities and as.character for labels for this
pred <- predict(model,test, type='class')
# compute accuracy
correct <- cbind(actual = factor(pred), expected = test_section) %>% data.frame %>% filter(actual == expected) %>% nrow
accuracy <- correct/nrow(test)

# look at the confusion matrix
confusionMatrix <- table(factor(pred), test_section)

# plot an ROC curve and calculate the AUC
# (see last week's notebook for this)
prob <- predict(model, test, type='response')
predObject <- prediction(prob,test_section)
perf <- performance(predObject,measure='tpr', x.measure='fpr')
plot(perf)
performance(predObject,'auc')
# show weights on words with top 10 weights for business
# use the coef() function to get the coefficients
# and tidy() to convert them into a tidy data frame
weights <- tidy(coef(model)) %>% select(term=row, weight=value)

weights %>% arrange(weight) %>% head(10)
# show weights on words with top 10 weights for world
weights %>% arrange(desc(weight)) %>% head(10)

