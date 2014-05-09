$ ->

  is_homepage = $('body').hasClass 'is-homepage'
  window_height = $(window).height()
  minimum_height = 400

  if is_homepage

    set_heights = ->
      use_height = if window_height > minimum_height then window_height else minimum_height

      $('.hero').css
        height: use_height

      $('body').css
        paddingTop: use_height

    recalculate_heights = ->
      window_height = $(window).height()
      set_heights()

    set_heights()

    $(window).resize ->
      recalculate_heights()
