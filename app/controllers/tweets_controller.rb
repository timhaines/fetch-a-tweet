class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def new
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    tweet_from_twitter = get_tweet_from_twitter(params[:tweet][:tweet_id].to_i)
    @tweet = Tweet.new

    if tweet_from_twitter
      @tweet.user = tweet_from_twitter.user.name
      @tweet.tweet_id = tweet_from_twitter.id
      @tweet.content = tweet_from_twitter.text
      # @image = t[:profile_image_url]

      respond_to do |format|
        if @tweet.save
          format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end

    else
      @error = "Sorry that tweet doesn't exist. Try again?"
      render :action => 'new'
    end
  end

  protected
    def get_tweet_from_twitter(tweet_id)
      return Twitter.status(tweet_id)
    rescue
      # Could log error or do something else here.
      return nil
    end
end
