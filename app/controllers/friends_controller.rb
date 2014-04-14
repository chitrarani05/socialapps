class FriendsController < ApplicationController
  ###########
  ## Filters
  ###########
  ############
  ## Requires
  ############
  require 'will_paginate/array'
  require 'xmpp4r_facebook'
  require 'twitter'
  
  #############
  ## Constants
  #############
  ##################
  ## Public Actions
  ##################
  def index
    #debugger
    if current_user.provider == "facebook"
      @user_fb_token = current_user.token
      unless @user_fb_token.blank?
      #debugger
      #@fb_friends = FbGraph::User.me(@user_fb_token).friends.paginate(page: params[:page], per_page: 5)
      @fb_friends = FbGraph::User.me(@user_fb_token).friends
      #debugger
      @fb_friends = @fb_friends.sort_by { |fb_frnd| fb_frnd.raw_attributes['name']}
      #debugger
      end
      if params[:task].present?
     
        #me = FbGraph::User.me(current_user.token)
        params[:friends].keys.each do |key|
          sender_chat_id = "-#{current_user.uid}@chat.facebook.com"
          #debugger
          receiver_chat_id = "-#{params[:friends][key]}@chat.facebook.com"
          message_body = "#{params[:task]}"
          message_subject = "helloo.."

          jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
          jabber_message.subject = message_subject
          #debugger
          client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
          client.connect
          #debugger
          client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, 551323001609635, current_user.token, "8672a42476b5aaf3c69eb8af067a8b04"), nil)
          client.send(jabber_message)
          client.close
        end    
        flash[:notice] = "Message has been send"
      end
    elsif current_user.provider == "twitter"
    #debugger
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "60Bp7HQLUT6f4YX00kOBqg"
        config.consumer_secret     = "m2ZAbXYWJmE9w0cfuV0Pub8u7Izf7DXfyO5G5dKc"
        config.access_token        = "2239050950-aV4Q7T1JoxHEDtGv93qJuUueICBMjQAxzJcIOzX"
        config.access_token_secret = "v3qXdz83NqzqwAa07KKkqze5FVytCiFcfZ9pyblDRpTKz"
      end
      @friends = client.followers
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
