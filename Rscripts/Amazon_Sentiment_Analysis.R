# Section 1: Load and Prepare Data
# -------------------------------------------------------

# Clear workspace and load data
rm(list = ls())
data <- read.csv(file.choose(), header = TRUE)
data$label <- factor(data$ReviewStar, levels = c(1, 2, 4, 5), exclude = 3, labels = c("Negative", "Negative", "Positive", "Positive"))
data_amazon <- na.omit(data[data$ReviewBody != "", ])

# Section 2: Subset Data
# -------------------------------------------------------

#positive_reviews <- subset(data_amazon, label == "Positive")[1:1000, ]
#negative_reviews <- subset(data_amazon, label == "Negative")[1:1000, ]
#data_amazon <- rbind(positive_reviews, negative_reviews)

# Section 3: Sentiment Analysis
# -------------------------------------------------------
library(syuzhet)
library(sentimentr)
library(meanr)
library(paletteer)

afinn <- as_key(syuzhet:::afinn)

out <- data.frame(
  data_amazon,
  sentimentr_hu_liu = sentiment_by(data_amazon$ReviewBody, polarity_dt = lexicon::hash_sentiment_huliu, question.weight = 0)[["ave_sentiment"]],
  sentimentr_sentiword = sentiment_by(data_amazon$ReviewBody, polarity_dt = lexicon::hash_sentiment_sentiword, question.weight = 0)[["ave_sentiment"]],
  sentimentr_jockers = sentiment_by(data_amazon$ReviewBody, polarity_dt = lexicon::hash_sentiment_jockers, question.weight = 0)[["ave_sentiment"]],
  sentimentr_afinn = sentiment_by(data_amazon$ReviewBody, polarity_dt = afinn, question.weight = 0)[["ave_sentiment"]],
  sentimentr_nrc = sentiment_by(data_amazon$ReviewBody, polarity_dt = lexicon::hash_sentiment_nrc, question.weight = 0)[["ave_sentiment"]],
  sentimentr_loughran_mcdonald = sentiment_by(data_amazon$ReviewBody, polarity_dt = lexicon::hash_sentiment_loughran_mcdonald, question.weight = 0)[["ave_sentiment"]],
  meanr = meanr::score(data_amazon$ReviewBody)$score,
  syuzhet_ = setNames(as.data.frame(lapply(c("syuzhet", "bing", "afinn", "nrc"),
                                           function(x) get_sentiment(data_amazon$ReviewBody, method=x))),
                      paste0("", c("syuzhet", "bing", "afinn", "nrc"))),
  stringsAsFactors = FALSE
)

out1<-out

# Subset the relevant columns
out <- out1[5:16]

# Map sentiment scores to labels (Positive, Negative, Neutral)
out[out > 0] <- "Positive"
out[out < 0] <- "Negative"
out[out == 0 ] <- "Neutral"

# Add the original text column to the result
out$text <- out1$ReviewBody

# Section 4: Accuracy Calculation and Plot
# -------------------------------------------------------
library(dplyr)
library(caret)

reference <-out$label

calculate_accuracy <- function(predicted, reference, lexicon_name) {
  u <- union(predicted, reference)
  t <- table(factor(predicted, u), factor(reference, u))
  accuracy <- confusionMatrix(t)$overall[1]
  data.frame(Lexicon = lexicon_name, Accuracy = accuracy)
}

lexicons <- c('sentimentr_hu_liu', 'sentimentr_loughran_mcdonald', 'sentimentr_sentiword',
              'sentimentr_jockers','sentimentr_afinn', 'sentimentr_nrc',
              'meanr', 'syuzhet_.syuzhet','syuzhet_.bing', 'syuzhet_.afinn', 'syuzhet_.nrc')

df <- data.frame(Lexicon = character(), Accuracy = numeric())

for (lexicon in lexicons) {
  predicted <- out[[lexicon]]
  accuracy_df <- calculate_accuracy(predicted, reference, lexicon)
  df <- bind_rows(df, accuracy_df)
}



sorted_df <- df[order(df$Accuracy, decreasing = TRUE), ]

# Printing sorted accuracy dataframe
print(sorted_df)



# Load the necessary packages
library(ggplot2)
library(forcats)


# Creating a bar plot with values using minimal color and style
ggplot(df, aes(fct_reorder(Lexicon, Accuracy), Accuracy, fill = Lexicon)) +
  scale_fill_brewer(palette = "Paired", type = "qual", aesthetics = c("fill")) +  # Use a minimal color palette from RColorBrewer
  geom_col() +
  geom_text(aes(label = sprintf("%.1f%%", Accuracy * 100)), vjust = 0.5, size = 5, color = "black") +  # Add accuracy values on top of bars with black text
  labs(x = "Lexicon", y = "Accuracy", title = "Lexicon Based Sentiment Accuracy Comparison of Amazon Reviews") +
  theme_minimal() +  # Use a minimal theme
  theme(legend.position = "none", axis.text.x = element_text(angle = 45, hjust = 1)) +  # Adjust axis text
  coord_flip()




# Load necessary libraries
library(pacman)
library(tm)
p_load(sentimentr, tidyverse, lexicon, textshape, textreadr, janeaustenr, textclean)
p_load_current_gh('trinker/sentimentr', 'trinker/numform', 'trinker/textcorpus')
p_load(rvest, xml2)

# Build corpus
corpus <- iconv(out$text, to = "utf-8-mac")
corpus_v <- Corpus(VectorSource(corpus))
inspect(corpus_v[1:5])


library(quanteda)

# valence shifter analysis

attributes_rate <- list(
  sentiment_attributes(corpus_v))    %>%
  lapply(function(y){
    x <- y[['Polarized_Cooccurrences']]
    data.frame(setNames(as.list(f_prop2percent(x[[2]], 0)), gsub('-', '', x[[1]])), 
               stringsAsFactors = FALSE, check.names = FALSE)
  }) %>%
  setNames(c('Amazon Reviews')) %>%
  tidy_list('text')


# Save sentiment analysis results
saveRDS(attributes_rate, 'attributes_rate.rds')



# Display sentiment analysis results
attributes_rate






# Add the label column from out1 to out
out$label <- out1$label

# Create a dataframe with reviews predicted as "Neutral" by all lexicons
common_neutral_reviews <- out %>%
  filter(
    sentimentr_jockers == "Neutral" &
      syuzhet_.afinn == "Neutral" &
      sentimentr_hu_liu == "Neutral" &
      sentimentr_sentiword == "Neutral" &
      sentimentr_loughran_mcdonald == "Neutral" &
      sentimentr_afinn == "Neutral" &
      sentimentr_nrc == "Neutral" &
      meanr == "Neutral" &
      syuzhet_.syuzhet == "Neutral" &
      syuzhet_.bing == "Neutral" &
      syuzhet_.nrc == "Neutral"
  )


# Create a comparison dataframe with the predicted "Neutral" reviews
comp_df <- data.frame(
  Predicted_Neutral_by_All = common_neutral_reviews$text,
  Ratting = common_neutral_reviews$label
)

# Remove the common neutral reviews from the dataset for final accuracy analysis
final_out <- out[!(out$text %in% comp_df$Predicted_Neutral_by_All), ]
reference <- final_out$label



# Predicted sentiment by one of the lexicons (e.g., sentimentr_jockers)
predicted <- final_out$sentimentr_jockers

# Ensure levels are the same for both predicted and reference vectors
all_levels <- union(levels(factor(predicted)), levels(factor(reference)))

# Create a confusion matrix
conf_matrix <- table(factor(predicted, levels = all_levels), factor(reference, levels = all_levels))

# Subset the confusion matrix to remove the 'Neutral' category
conf_matrix_ <- conf_matrix[c("Negative", "Positive"), c("Negative", "Positive")]

# Print the resulting 2x2 confusion matrix
print(conf_matrix_)


#colorful plot of confusion matrix

fourfoldplot(conf_matrix_, color = c("pink", "lightblue"), conf.level = 0, margin = 1, main = "Sentiment_Jokers_lexicon Confusion Matrix")


#####


library(mltools)
dfmcc<-data.frame()

mcc(TN=conf_matrix_[1,1],TP=conf_matrix_[2,2],FP=conf_matrix_[1,2],FN=conf_matrix_[2,1])


library(grDevices)
library(RColorBrewer)

library(caret)
confusionMatrix((final_out$sentimentr_jockers), as.factor(final_out$label))
