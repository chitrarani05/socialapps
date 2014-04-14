class PostsController < ApplicationController
  ###########
  ## Filters
  ###########
  ############
  ## Requires
  ############
  #############
  ## Constants
  #############
  ##################
  ## Public Actions
  ##################
  def index
    #debugger
    #@user_fb_token = current_user.token
    if current_user.provider == "facebook"
      if params[:share].present?
        #debugger
        #FbGraph.post 'https://graph.facebook.com/me/feed', { :access_token => @user_fb_token, :message => params[:share] }
        me = FbGraph::User.me(current_user.token)
        me.feed!(
          :message => "#{params[:share]}",
          :picture => 'https://graph.facebook.com/matake/picture',
          :link => 'https://www.google.com',
          :name => 'Search by Google',
          :description =>  'Done'
        )
        flash[:notice] = "Post has been shared"
      else
        flash[:notice] = "Put somthing to post"
      end
    else
      if params[:share].present?
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = "60Bp7HQLUT6f4YX00kOBqg"
          config.consumer_secret     = "m2ZAbXYWJmE9w0cfuV0Pub8u7Izf7DXfyO5G5dKc"
          config.access_token        = "2239050950-aV4Q7T1JoxHEDtGv93qJuUueICBMjQAxzJcIOzX"
          config.access_token_secret = "v3qXdz83NqzqwAa07KKkqze5FVytCiFcfZ9pyblDRpTKz"
        end
      client.update(params[:share]) 
      #debugger
      end
      #client.update("I'm tweeting with twitter gem!")
    end  
  end
  
  #####################
  ## Protected Methods
  #####################
  protected

  ###################
  ## Private Methods
  ###################
  private

end  
