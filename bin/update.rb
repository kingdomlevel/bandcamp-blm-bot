# load environment variables
require 'dotenv'
Dotenv.load

require("twitter")

ACCOUNT_NAME = "bandcampBLMbot"
search_string = 'bandcamp donate ("black lives matter" OR "blm" OR bail) filter:links'

twitter = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

# get tweets for purpose of de-duplication
account_tweets = twitter.user_timeline(ACCOUNT_NAME)

# perform twitter search
latest_tweets = twitter.search(search_string, result_type: "recent").take(10);

tweet_count = 0

latest_tweets.take(10).each do |tweet|

    # only tweet if hasn't been tweeted before,
    # and there have been less than 5 tweets in this cycle so far
    unless (account_tweets.include?(tweet) || tweet_count > 5 || tweet.user.name=="Yoni Den")
        tweet_count += 1
        twitter.retweet tweet
    end
end

puts "🦉retweeted #{tweet_count}"


