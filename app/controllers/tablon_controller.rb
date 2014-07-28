class TablonController < ApplicationController
	layout "application"
	def index
		@hashtag_tablon = params[:hashtag]
		@query= client.user_timeline(:include_entities=>true, :count => 3200, :include_rts=> true)
		@tablon = Array.new
		@i=0

		@usuario = 'instanttertest'      
	    db = get_connection
	    coll = db.collection('usuarios')

		for tweet in @query
			if tweet.hashtags != []
				if tweet.hashtags[0]['text'] == @hashtag_tablon
            		@tablon[@i]=ApplicationHelper::Ttweet.new(tweet.id, tweet.user.username, auto_link(tweet.text.dup.force_encoding("UTF-8"), target: '_blank'),tweet.media,tweet.urls)
            		@i=@i+1
        		end
        	end
        end

        coll.update({"usuario"=>@usuario,  "tablones.hashtag" => @hashtag_tablon }, {"$set" => {"tablones.$.publicaciones" => @i}})
 
    end
end