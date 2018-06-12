class ChainController < ApplicationController
  def index
    text = "In fact, though we may all like to think of ourselves as the next Shakespeare, inspiration alone is not the key to effective essay writing. You see, the conventions of English essays are more formulaic than you might think on the issue at hand but effective introductory paragraphs are so much more than that Finally, designing the last sentence in this way has the added benefit of seamlessly moving the reader to the first paragraph of the body of the paper. In this way we can see that the basic introduction does not need to be much more than three or four sentences in length"
    @substring = new_tweet(text)
  end

  private

  def get_markov_ratio(string)
    result = {}
    length = string.length
    for i in 0..(length - 3) do
      substring = string[i,3]
      next_char = string[i + 3, 1]

      if !result[substring]
        result[substring] = []
      end

      result[substring].push(next_char)
    end
    result
  end

  def new_tweet(input_text)
    curr_ngram = input_text[0,3]
    new_tweet = curr_ngram
    tweet_char_limit = 280
    markov_hash = get_markov_ratio(input_text)

    while new_tweet.length < tweet_char_limit
      markov_array = markov_hash[curr_ngram]
      markov_next_char = markov_array.sample.to_s
      if markov_next_char == ""
        return new_tweet
      end
      new_tweet += markov_next_char
      curr_ngram = new_tweet.split("").last(3).join
    end
    new_tweet
  end
end
