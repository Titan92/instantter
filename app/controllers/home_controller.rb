class HomeController < ApplicationController

	layout "application"

	def index
		perfil
	end

	def perfil
	    if session['access_token'] && session['access_token_secret']   
	      #if false  #bloque comentado
	      @peticion = client.user
	      @img_usuario = @peticion.profile_image_url(:original) #normal, bigger, mini, original
	      @usuario = @peticion.username
	      @nombre = @peticion.name
	      @descripcion = @peticion.description
	      @tuits =  @peticion.tweets_count
	      @followers = @peticion.followers_count
	      @following =  @peticion.friends_count 
	     # end #bloque comentado
	       
	      @usuario = 'instanttertest'      
	      db = get_connection
	      coll = db.collection('usuarios')
	      
	      #Si el usuario no existe en la bd creamos uno nuevo
	      record = coll.find({usuario: @usuario}).to_a      
	      if record==[]  # <----  Si, eso es como un NULL 
	        coll.insert({usuario:  @usuario, tablones: [], tablones_publicos: [], tablones_colectivos: []})
	      end
	      
	      usuariobd = coll.find({usuario: @usuario}).to_a 
	      usuariobd.each do |usuario|
	        @tablones = usuario["tablones"] 
	        @tablones_publicos = usuario["tablones_publicos"]
	        @tablones_colectivos = usuario["tablones_colectivos"]
	      end



	    else
	        redirect_to landpage_path
	    end
	end

end
