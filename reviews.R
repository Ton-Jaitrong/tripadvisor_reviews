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

#getwd()
#setwd("D:/R")

pages = 1

#reviews
for(i in 0:pages){
  #https://www.tripadvisor.com/ShowForum-g293920-i5037-o20-Phuket.html
  #https://www.tripadvisor.com/ShowForum-g293920-i5037-o40-Phuket.html
  
  url <- paste0("https://www.tripadvisor.com/ShowForum-g293920-i5037-", i*20 ,"-Phuket.html")
  
  reviews_page <- html_session(url)
  reviews <- read_html(reviews_page)
  
  # http://bradleyboehmke.github.io/2015/12/scraping-html-tables.html
  tbls <- html_nodes(reviews, "table")
  #head(tbls)
  
  tbls_ls <- as.data.frame(tbls %>% html_table(fill = TRUE))
  #str(tbls_ls)
  
  View(tbls_ls)
}

#topic
url <- paste0("https://www.tripadvisor.com/ShowTopic-g293920-i5037-k13481056-Fingers_crossed_Aussies_can_return_in_2022-Phuket.html")
topic_page <- html_session(url)
topic <- read_html(topic_page)

topic_title <- topic %>%
  html_nodes(".topTitleText") %>%
  html_text()

topic_Post <- topic %>%
  html_nodes(".postBody") %>%
  html_text()