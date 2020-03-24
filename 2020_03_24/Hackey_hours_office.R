library(schrute)

officedata <- schrute::theoffice

Seasons <- as.character(c("01", "02", "03","04","05","06","07","08","09"))

stop_words <- tidytext::stop_words
SeasonData<- list()

for(nseason in Seasons){
  # Created a new DF that will store the data for each subsequent step
    df.loop <- officedata
  # Filtered the data based in the number of seasons
    df.loop <- dplyr::filter(.data = df.loop, season == nseason)
  # Separated each word of the text into new rows
    df.loop <- tidytext::unnest_tokens(df.loop, word, text)
  # Removed all the stop words
    df.loop <- dplyr::anti_join(df.loop, stop_words, by = "word")
  # Count the words
    df.loop <- dplyr::count(df.loop, word, sort = TRUE)
  # Extract the top 30
    df.loop <- dplyr::top_n(df.loop, 30)
  # Reorganize them by incidence
    df.loop <- dplyr::mutate(df.loop, word = stats::reorder(word, n))
  # save the dataframe into a list
    SeasonData[[nseason]]<- df.loop
}    

ggplot2::ggplot(SeasonData[[2]], ggplot2::aes(x=word, y=n))+
  ggplot2::geom_col()+
  ggplot2::coord_flip()
