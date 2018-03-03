# Oscars Script Analysis — 1989, 2015 and 2017

This repository contains data, analytic code, and findings supporting BuzzFeed News's [analysis of diversity in the dialogue of Best Picture–nominated films](https://www.buzzfeed.com/lamvo/oscars-script-diversity-analysis), published March 2, 2018. Please read that article, which contains important context and details, before proceeding.

## Data

This analysis relies on two data files, both found in `data/`.

`data/actor-metrics.csv` lists each actor in our analysis, and contains these columns:

  - `year`: Year the film was released
  - `film`: The film's name (shortened in some cases)
  - `actor` Actor name as found on IMDB or Variety Insights
  - `characters`: Character names/references, as found in screenplay 
  - `imdb`: IMDB link for reference
  - `gender`: Actor gender, as found on Variety Insights
  - `race`: Actor race, as found on Variety Insights and supplemented with additional reporting
  - `race_simple`: Simplified actor race — either `White` or `POC` (person of color)
  - `words`: Number of words spoken
  - `sentences`: Number of sentences spoken (not used in published article, but provided for reference and context)

`data/character-word-counts-csv` counting each `character + word` combination (excluding "stop words"; see below for details), for each actor in our analysis. It contains these columns: 

  - `year`: Year the film was released
  - `film`: The film's name (shortened in some cases)
  - `character`: Character name/reference, as found in screenplay 
  - `actor`: Actor name as found on IMDB or Variety Insights
  - `word`: Word this character spoke in this film
  - `count`: Number of times this word is uttered by this character

## Data sources

The analyses in this repository use, as their main source material, the scripts of the 22 films nominated for Best Picture for the 1990, 2016, and 2018 Academy Awards. (Those films were released in 1989, 2015, and 2017, respectively.) 

For two films, *Mad Max* and *My Left Foot*, we could not locate a script, so we instead relied on film *transcripts*, which we then checked against the final film. We then entered these transcripts into the [Writer Duet](https://writerduet.com/script) scriptwriting program, and exported the results as XML (in the same format that we used for other screenplays).

The list of nominated films came from the [Oscars Awards Database](http://awardsdatabase.oscars.org/) and the [Oscar's website](https://www.oscars.org/oscars/ceremonies/2018).

The character names and dialogue were extracted from film scripts, which were found on public websites (such as [Script Slug](http://scriptslug.com) and [The Internet Movie Script Database](http://www.imsdb.com/)) and on the websites of various film distributors.

It is __important to note__:

- Movie scripts are often imperfectly structured and can contain errors. Irregularities in writing styles and syntax can make it difficult to correctly attribute dialogue to the associated characters. We have attempted to standardize the data where we could. 
- Movie scripts also sometimes differ from what ultimately appears on screen.

The official names for each script's characters were drawn from [Variety Insights](https://www.varietyinsight.com/) and [IMDB](http://www.imdb.com/).

The source for each actor's actor gender and race/ethnicity was primarily [Variety Insights](https://www.varietyinsight.com/). In cases where an actor's gender race/ethnicity could not be confirmed in Variety Insights, we sometimes made a judgment call based on photos, biographies and other information. In cases where an actor's ethnicity or gender was at all in question, we confirmed the facts with their representative.

In some cases, names could not be matched to actors either because the character's part was not included in the finished film, or because the actor was not credited. These names were removed from the analysis.

## Data processing steps

First, we converted PDFs of the movie scripts into XML files, using [Writer Duet](https://writerduet.com/convert#convert) or [Story Writer](https://storywriter.amazon.com/dashboard). Then, we used Python's [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/), [TextBlob](http://textblob.readthedocs.io/en/dev/), and [ftfy](https://ftfy.readthedocs.io/en/latest/) libraries to extract the character names and dialogue from the XML files, clean them up, and "tokenize" the dialogue into sentences and words. Then, we exported each character's lines and total word and sentence counts to a CSV file.

Using that CSV file, we manually assigned each character we could to an actor, using the sources listed above. Then, we removed characters who fit any of the following criteria:

- Characters who could not be matched to an actor (for example, because they were not clearly credited)
- Characters who appeared in the script but ultimately not in the film
- Characters who spoke fewer than 100 words — largely because such characters are often unnamed (e.g., "PATIENT 1") and difficult to match to actors

Ultimately, we removed 11 characters who *did* speak at least 100 words:

- "RADIO," from `born-on-the-fourth-of-july` (176 words)
- "MAN," from `bridge-of-spies` (269)
- "ANNOUNCER," from `bridge-of-spies` (120)
- "NARRATOR," from `call-me-by-your-name` (317)
- "SOLDIER," from `dunkirk` (112)
- "BLACK," from `the-big-short` (154)
- "MODERN TRADER" from `the-big-short` (387)
- "YOUNG BANKER," from `the-big-short` (108)
- "BRAZEAU," from `the-revenant` (155)
- "PIG", from `the-revenant` (323)
- "RUNTY MAN," from `the-revenant` (210)

To generate the `character-word-counts.csv` file, we took the following steps:

- Extracted the dialogue from each script, per the above. In all TextBlob library identified 181,547 total words.
- Removed so-called "stop words", common words in the English language, and "words" that contained no alphabetic characters (e.g., "12"). That reduced the word count to 56,023. For this analysis, the list of exclusions contains approximately 600 stop words, such as `I`, `you` and `me`. These stop words were drawn from the [Natural Language Tool Kit](https://pythonspot.com/nltk-stop-words), [MySQL](https://dev.mysql.com/doc/refman/5.5/en/fulltext-stopwords.html), and editorial judgment based on very-commonly occurring words in the scripts. For reference, you can find the official NLTK stopwords in `data/stopwords-nltk.txt` and the additional custom and MySQL words in `data/stopwords-other.txt`.
- Counted the number of times each character said each of the remaining words.

## Analysis

This repository uses Python code and Jupyter notebooks to process the data. That code can be found here:

- [`casting_stats.ipynb`](notebooks/casting_stats.ipynb): This notebook loads `data/actor-metrics.csv` file and uses to compute descriptive statistics on character-, word-, and sentence-counts by year, film, gender, and race/ethnicity.

- [`calculate_word_frequencies.ipynb`](notebooks/calculate_word_frequencies.ipynb): This notebook loads data from `data/character-word-counts.csv` and `data/actor-metrics.csv`, uses them to create `output/top-words-by-gender.csv` and `top-words-by-race.csv`.

## Feedback / Questions?

Contact Lam Thuy Vo at lam.vo@buzzfeed.com and Scott Pham scott.pham@buzzfeed.com.

Looking for more from BuzzFeed News? [Click here for a list of our open-sourced projects, data, and code](https://github.com/BuzzFeedNews/everything).
