class ChainController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :handle_submit

  def index
    if params["markov_tweet"]
      puts "found markov"
      @markov_tweet = params["markov_tweet"]
    else
      puts "markov empty"
      @markov_tweet = "New tweet will appear here!"
    end
  end

  def handle_submit
    username = params[:username]

    twitter_service = TwitterService.new()
    text = twitter_service.text_string(username)

    new_tweet = make_new_tweet(text)

    @markov_tweet = new_tweet

    respond_to do |format|
      # if the response fomat is html, redirect as usual
      format.html { redirect_to root_path }

      # if the response format is javascript, do something else...
      format.js { }
    end
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

  def make_new_tweet(input_text)
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
