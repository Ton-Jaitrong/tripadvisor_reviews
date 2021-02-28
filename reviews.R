library(rvest)
library(plyr)
library(jsonlite)
library(readr)
library(stringi)

library(DBI)
library(dplyr)
library(dbplyr)
library(RODBC)

library(gdata)

#setwd("D:/R")

pages = 153

df <- data.frame()

#reviews
for(i in 1:pages){
  i = 1
  url <- paste0("https://www.tripadvisor.com/ShowForum-g293920-i5037-", i*20 ,"-Phuket.html")
  
  reviews_page <- html_session(url)
  reviews <- read_html(reviews_page)
  
  tbls <- html_nodes(reviews, "table")
  
  #forum <- html_nodes(tbls, ".forumcol") %>% html_text()
  topic <- html_nodes(tbls, "b") %>% html_nodes("a") %>% html_text()
  topic <- gsub("\r","",topic)
  topic <- gsub("\n","",topic)
  topic_link <- html_nodes(tbls, "b") %>% html_nodes("a") %>% html_attr("href")
  #created <- html_nodes(tbls, ".bymember") %>% html_text()
  #replies <- html_nodes(tbls, ".reply ") %>% html_text()
  #lastpost <- html_nodes(tbls, ".datecol ") %>% html_text()
  
  if(nrow(df)==0){
    df <- data.frame(topic, topic_link, stringsAsFactors = FALSE)
  } else{
    temp <- df
    df <- rbind(temp, data.frame(topic, topic_link, stringsAsFactors = FALSE))
  }
}
write.csv(df, "forums.csv")

#topic

df_topic <- data.frame()
df <- read_csv("forums.csv")
rows_count <- nrow(df)
for(j in 1:rows_count){
  url <- paste0("https://www.tripadvisor.com", df[j, "topic_link"])
  topic_session <- html_session(url)
  topic <- read_html(topic_session)
  
  topic_title <- topic %>%
    html_nodes(".topTitleText") %>%
    html_text()
  
  topic_post <- topic %>%
    html_nodes(".postBody") %>%
    html_text()
  topic_post <- gsub("\n","",topic_post)
  
  for(k in 1:length(topic_post)){
    if(nrow(df_topic)==0){
      df_topic <- data.frame(topic_title, topic_post[k], stringsAsFactors = FALSE)
    }else{
      temp <- df_topic
      df_topic <- rbind(temp, data.frame(topic_title, topic_post[k], stringsAsFactors = FALSE))
    }
  }
}
write.csv(df_topic, "topics.csv")





