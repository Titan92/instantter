require 'twitter-text'
module ApplicationHelper
  #CONVERTIR TEXTOS DE LINK EN ENLACES
  include Twitter::Autolink
  
  class Ttweet
  	def initialize (id,usuario, texto, imagenes, urls)
  		@id = id
  		@usuario = usuario
  		@texto = texto
  		@imagenes = imagenes
  		@urls = urls
      @url_instagram
      if urls != []
            @url_aux = urls[0]['expanded_url'].to_s 
            if @url_aux.to_s.include? 'instagram.com/p/' 
              @url_instagram = @url_aux
            end
      end
  	end
  	def id
        @id
    end
    def usuario
        @usuario
    end
    def texto
        @texto
    end
    def imagenes
        @imagenes
    end
    def urls
        @urls
    end
    def url_instagram
        if @url_instagram != []
          if @url_instagram.to_s.include? 'instagram.com/p/'
            if @url_instagram.last().to_s != '/'
                puts 'Error Instagram fixed'
                @url_instagram = @url_instagram.to_s+'/'
            end
            @url_instagram_procesada = @url_instagram.to_s + 'media/?size=l'
          end
        end
        @url_instagram_procesada
    end 
  end

  class Ttablon
  	def initialize (id, hashtag, publico, fecha_creacion, tweets)
  		@id = id
  		@hashtag = hashtag
  		@publico = publico
  		@fecha_creacion = fecha_creacion
  		@tweets = tweets
  	end
  	def id
        @id
    end
    def hashtag
        @hashtag
    end
    def publico
        @publico
    end
    def fecha_creacion
        @fecha_creacion
    end
    def tweets
        @tweets
    end
  end

  def get_connection
      return @db_connection if @db_connection
      db = URI.parse('mongodb://instantter:instantter@kahana.mongohq.com:10044/instantter_db')
      db_name = db.path.gsub(/^\//, '')
      @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
      @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
      @db_connection
  end

  def botones_tablones
    @usuario = 'instanttertest'      
    db = get_connection
    coll = db.collection('usuarios')

    usuariobd = coll.find({usuario: @usuario}).to_a 
    usuariobd.each do |usuario|
       @tablones = usuario["tablones"]
    end
  end

end