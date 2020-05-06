library(tidytext)
library(ggplot2)
library(tidyr)
library(dplyr)

library(wordcloud)
library(RColorBrewer)
library(wordcloud2)

#default for read.table/ read.csv is to convert to factors, throw on colClasses
#tidytext will not work on factors
vac <- read.csv("C:/Users/Pat/Documents/.R/vaccination2.csv", colClasses = "character")
sub_vac <- vac[,c("username","date","tweet")]

#break each tweet into a seperate word
token_sub_vac <- sub_vac %>% 
  tidytext::unnest_tokens(word, tweet)

#import stop words
stop_words <- tidytext::stop_words

#remove stop words
tidy_token_sub_vac <- token_sub_vac %>%
  dplyr::anti_join(stop_words, by = "word")

word_count <- tidy_token_sub_vac %>%
  dplyr::count(word, sort = TRUE)

#ggplot of words used at least 2000 times
tidy_token_sub_vac %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::filter(n > 2000) %>%
  dplyr::mutate(word = stats::reorder(word, n)) %>%
  ggplot2::ggplot(ggplot2::aes(word, n)) +
  ggplot2::geom_col() +
  ggplot2::xlab(NULL) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal()

#cleaning remove some words
cleaned_tidy_token_sub_vac <- tidy_token_sub_vac[!(tidy_token_sub_vac$word=="bit.ly" |tidy_token_sub_vac$word=="https" | tidy_token_sub_vac$word=="pic.twitter.com" | tidy_token_sub_vac$word=="http" | tidy_token_sub_vac$word=="twitter.com" | tidy_token_sub_vac$word=="2" | tidy_token_sub_vac$word=="1" | tidy_token_sub_vac$word=="3"),]

#ggplot of words used at least 2000 times
cleaned_tidy_token_sub_vac %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::filter(n > 2000) %>%
  dplyr::mutate(word = stats::reorder(word, n)) %>%
  ggplot2::ggplot(ggplot2::aes(word, n)) +
  ggplot2::geom_col() +
  ggplot2::xlab(NULL) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal()

#convert to "latin1" or "UTF-8" if there is a diff in conversion drop
cleaned_tidy_token_sub_vac$convert <- iconv(cleaned_tidy_token_sub_vac$word)
cleaned_tidy_token_sub_vac <- cleaned_tidy_token_sub_vac[cleaned_tidy_token_sub_vac$word == cleaned_tidy_token_sub_vac$convert,]
  
#ggplot of words used at least 2000 times
cleaned_tidy_token_sub_vac %>%
  dplyr::count(word, sort = TRUE) %>%
  dplyr::filter(n > 2000) %>%
  dplyr::mutate(word = stats::reorder(word, n)) %>%
  ggplot2::ggplot(ggplot2::aes(word, n)) +
  ggplot2::geom_col() +
  ggplot2::xlab(NULL) +
  ggplot2::coord_flip() +
  ggplot2::theme_minimal()

bing <- get_sentiments("bing")

vac_sentiment <- cleaned_tidy_token_sub_vac %>%
  inner_join(bing) %>%
  count(date, word, sentiment) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative)

#sentiment by date
ggplot(vac_sentiment, aes(date, sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE)

ggplot(vac_sentiment, aes(sentiment)) + 
  geom_histogram(bins = 100)

#word counts
set.seed(1234) # for reproducibility 
wordcloud(words = word_count$word, freq = word_count$n, min.freq = 10,
          max.words=200, random.order=FALSE, rot.per=0.35,
          colors=brewer.pal(8, "Dark2"))

wordcloud2(data=word_count, size=1.6, color='random-dark')
