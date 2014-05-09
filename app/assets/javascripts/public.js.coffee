$ ->

  # Variables
  is_homepage = $('body').hasClass 'is-homepage'
  window_height = $(window).height()
  minimum_height = 400

  # Functions
  set_heights = ->
    if is_homepage
      use_height = if window_height > minimum_height then window_height else minimum_height

      $('.hero').css
        height: use_height

      $('body').css
        paddingTop: use_height
    else

      $('.hero').css
        height: ''

      $('body').css
        paddingTop: ''

  body_position = ->
    console.log "#{$(document).height()}/#{window_height}"
    if $(document).height() > window_height
      $('body').css
        position: 'relative'
    else
      $('body').css
        position: 'static'

  # Listeners
  $(window).resize ->
    window_height = $(window).height()
    set_heights()
    body_position()

  # Initialize
  set_heights()
  body_position()



