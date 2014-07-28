// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).ready(function(){

  $( ".gatillo_menu" ).click(function() { 
    if($('nav').hasClass('desplegado')){
      $('nav').removeClass('desplegado');
    } 
    else {
       $('nav').addClass('desplegado');      
    }
  });  
  /* Nuevo Tweet */
  $( ".trigger_tweet" ).click(function() {
      $('nav').removeClass('desplegado');
       $('.overlay_tuitear').addClass('desplegado');
       contarCaracteres();
       $('.texttweet').focus();
  });

  $( ".trigger_nuevo_tablon" ).click(function() {
      $('nav').removeClass('desplegado');
        if($('.nuevo_tablon_wrapper').hasClass('desplegado')) {
          $('.nuevo_tablon_wrapper').removeClass('desplegado'); 
          $('.nuevo_tablon_wrapper').slideUp('fast');
        }
          else {
            $('.nuevo_tablon_wrapper').addClass('desplegado'); 
            $('.nuevo_tablon_wrapper').slideDown('fast');
            $('#nuevo_hashtag').focus();
        } 
  });
 
  
  $( ".overlay_tuitear, .close_tuitear" ).click(function() {
       $(".confirm_tweet").html('');
       $('.overlay_tuitear').removeClass('desplegado');      
  });
  
  $( ".overlay_contenedor" ).click(function(event) { 
       event.stopPropagation();     
  });

  
  $( "#bt_reset_tweet" ).click(function() {
    $('.texttweet').val("");
    $('.texttweet').focus();
    contarCaracteres();
  });

  $( "#bt_send_tweet" ).click(function() {
	  /*$.ajax({type: 'get', 
	  	url: "/sendtweet", 
      data: { tuit:  $(".texttweet" ).val() },
	  	success: function (response) {
                    $(".caracteres").html(140)
                    $(".caracteres").css({ color: "#777"});
                    $( "#btn_update" ).trigger('click');
                    $(".texttweet").val("");
                    $(".confirm_tweet").css({ color: "#00ff00"});
                    $( ".confirm_tweet" ).html(response);
                }, 
	  	error: function() {
        $(".confirm_tweet").css({ color: "#ff0000"});
        if($(".texttweet").val().length == 0)
          $(".confirm_tweet").html('¡Venga va! Anímate y escribe algo.');
        else
          $(".confirm_tweet").html('Has superado los 140 caracteres. Acórtalo un poquito.');
      }
	   });
	  return(false); comentado porque la cuenta no está en write y da error  */
	});
  /* Fin Nuevo Tweet */
  

  $( "#crear_tablon" ).click(function(){
    if($("#nuevo_hashtag" ).val()!=''){
        $.ajax({type: 'get', 
          url: "/crear_tablon/"+$("#nuevo_hashtag").val(), 
          success: function (response){ 
            if($(".grid_board.tablones")[0]){ 
              $(".grid_board.tablones").html(response);
              
            }
          }, 
          error: function(){ }
        });
        $( ".trigger_nuevo_tablon" ).trigger( "click" );
        $("#nuevo_hashtag").val('');
    }
    else {
      //si falla algo
    }
    return(false);
  }); 

  $( ".botones_tweet_tablones > span" ).click(function(){
    
    if($('.texttweet').val()==""){
      $('.texttweet').val($(this).html()+" "); 
    }
    else {
      $('.texttweet').val($('.texttweet').val()+" "+$(this).html()+" "); 
    }
    
    contarCaracteres();
    $('.texttweet').putCursorAtEnd();
  }); 


  
  $( ".borrar_tablon" ).click(function(event) {  
       event.preventDefault(); 
       var borrar_hashtag = $(this).siblings(".board_hashtag").html();
       var limpiar_hastag = borrar_hashtag.substring(1, borrar_hashtag.length);

        $.ajax({type: 'get', 
          url: "/borrar_tablon/"+limpiar_hastag, 
          success: function (response){ 
            if($(".grid_board.tablones")[0]){ 
              $(".grid_board.tablones").html(response);
              
            }
          }, 
          error: function(){ }
      });
  });



});

jQuery.fn.putCursorAtEnd = function() {

  return this.each(function() {

    $(this).focus();

    // If this function exists...
    if (this.setSelectionRange) {
      // ... then use it (Doesn't work in IE)

      // Double the length because Opera is inconsistent about whether a carriage return is one character or two. Sigh.
      var len = $(this).val().length * 2;

      this.setSelectionRange(len, len);
    
    } else {
    // ... otherwise replace the contents with itself
    // (Doesn't work in Google Chrome)

      $(this).val($(this).val());
      
    }

    // Scroll to the bottom, in case we're in a tall textarea
    // (Necessary for Firefox and Google Chrome)
    this.scrollTop = 999999;

  });

};


function contarCaracteres(){
	  
	  $(".caracteres").html(140-$(".texttweet").val().length)
	      
	  if($(".texttweet").val().length > 130)
	    $(".caracteres").css({ color: "#ff0000"});
	  else
	    $(".caracteres").css({ color: "#777"});
 
}

