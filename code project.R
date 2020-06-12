if (!require(rtweet)) {install.packages('rtweet')}
if (!require(magrittr)) {install.packages('magrittr')}
if (!require(data.table)) {install.packages('data.table')}
if (!require(ggplot2)) {install.packages('ggplot2')}
if (!require(graphics)) {install.packages('graphics')}
if (!require(topicmodels)) {install.packages('topicmodels')}
if (!require(quanteda)) {install.packages('quanteda')}
if (!require(stats)) {install.packages('stats')}
if (!require(grDevices)) {install.packages('grDevices')}
if (!require(utils)) {install.packages('utils')}
if (!require(methods)) {install.packages('methods')}
# grab ??? 18*3 = 54 thousand tweets matching the query below
library(rtweet)

# A wrapper to search_tweets so that we do not have to give all
# this parameters more than once
mysearch = function(query,number.of.tweets, max_id = NULL) {
  tweets.df <- search_tweets(
    query,
    n = number.of.tweets,
    type = "recent",
    include_rts = FALSE, #No retweets, only original tweets!
    geocode = NULL,
    max_id = max_id,
    parse = TRUE,
    token = NULL,
    retryonratelimit = FALSE,
    verbose = TRUE,
    lang = "en",
    tweet_mode = "extended" # get 240 character tweets in full
  )
}

num_tweets = 18000 # search 18,000 tweets every time
query= 'Corona'
A.df = mysearch(query, num_tweets)
for (i in 1:3) {
  nrow_a = dim(A.df)[1]
  oldest_id = A.df$status_id[nrow_a]
  Sys.sleep(15*60)
  B.df = mysearch(query, num_tweets, max_id = oldest_id)
  nrow_b = dim(B.df)[1]
  A.df = rbind(A.df,B.df[2:nrow_b,])
  A.df = setDT(A.df)
  A.df = A.df[!duplicated(status_id)]
}
save(A.df,file = 'tweets.RProject')
