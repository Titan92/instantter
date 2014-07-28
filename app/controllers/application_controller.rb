require 'json'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  layout "ajax"

    def get_connection
      return @db_connection if @db_connection
      db = URI.parse('mongodb://instantter:instantter@kahana.mongohq.com:10044/instantter_db')
      db_name = db.path.gsub(/^\//, '')
      @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
      @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
      @db_connection
    end

    def creartablon
      hashtag=params[:hashtag]

      @usuario = 'instanttertest'      
      db = get_connection
      coll = db.collection('usuarios')
      
      t = Time.now
      coll.update({"usuario"=>@usuario },{"$push" => {"tablones" => { "hashtag"=> hashtag, "fecha"=> t.strftime("%d/%m/%Y"), "publicaciones"=> 0  }}} )

      usuariobd = coll.find({usuario: @usuario}).to_a 
      usuariobd.each do |usuario|
      @tablones = usuario["tablones"]
    end

      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end

    def borrartablon
      hashtag=params[:hashtag]

      @usuario = 'instanttertest'      
      db = get_connection
      coll = db.collection('usuarios')
       
      coll.update({"usuario"=>@usuario },{"$pull" => {"tablones" => { "hashtag"=> hashtag }}} )

      usuariobd = coll.find({usuario: @usuario}).to_a 
      usuariobd.each do |usuario|
      @tablones = usuario["tablones"]
    end

      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end

    def sendtweet
      text=params[:tuit]
      client.update(text) unless text == nil
      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end
    
    def favorite
      tweet_id=params[:tuit_id]
      client.favorite(tweet_id)  unless tweet_id == nil    
      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end
    
    def unfavorite
      tweet_id=params[:tuit_id]
      client.unfavorite(tweet_id)  unless tweet_id == nil
      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end
    
    def retweet
      tweet_id=params[:tuit_id]
      client.retweet(tweet_id)  unless tweet_id == nil
      
      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end
    
    def unretweet
      tweet_id=params[:tuit_id]
      #client.destroy(tweet_id)  unless tweet_id == nil     #¿COMO SE UNRETWITEARA?
      @usuario = client.user.username
      @retuits = client.search("from:"+@usuario , :include_entities=>true, :count => 2000)
      for tweet in @retuits
        if tweet.retweeted_status.nil?
        else
          if tweet.retweeted_status.id.to_s == tweet_id.to_s
            client.destroy_status(tweet.id)
          end
        end
      end
      
      respond_to do |format|
          format.html {  }
          format.json { head :no_content }
          format.js
      end
    end

   
  
    def client
    puts "*** Llamada a client ***"
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'TvZWbDeE1AYsygfTWRbWnsD2d'
      config.consumer_secret = 'h8TtfeivNmDnxLJa2FccVnjKqx6GhMxiiH6TxFNsSAzWaP8RbX'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_token_secret']
    end
  end
    
end
