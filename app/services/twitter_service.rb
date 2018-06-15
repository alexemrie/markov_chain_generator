class TwitterService
  def text_string(username)
    create_client
    tweets_array = get_tweets(@client, username)
    tweets_array.join(" ")
  end

  private

  def get_tweets(client, username)
    timeline = client.user_timeline(username)
    tweet_text_array = []

    timeline.each do |tweet|
      text = tweet.text
      text_convert = text.encode("UTF-8")
      tweet_text_array.push(text_convert)
    end
    tweet_text_array

  rescue Twitter::Error
    tweet_text_array = ["Error Not Found"]
  end

  def create_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"]
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]
    end
  end
end
