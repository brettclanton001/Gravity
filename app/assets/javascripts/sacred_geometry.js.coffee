$ ->

  is_homepage = $('body').hasClass 'is-homepage'

  if is_homepage

    n = 50   # number of overlapping circles
    d = 1200 # diameter of circles (px)
    r = d/2  # radius
    e = 0.85 # eye dilation
    c = ""   # circles html

    top = (i,e)->
      -r+(r*e)*Math.cos(2*Math.PI*i/n)

    left = (i,e)->
      -r+(r*e)*Math.sin(2*Math.PI*i/n)

    for i in [1..n]
      c += "<circle id=\"#{i}\" style=\"width:#{d}px; height:#{d}px; top:#{top(i,e)}px; left:#{left(i,e)}px;\"></circle>"

    $('circles').html c

    set_dilation = (dil)->
      for i in [1..n]
        t = top(i,dil)
        l = left(i,dil)
        $("circle##{i}").css
          top: "#{t}px",
          left: "#{l}px"

    dilate = ->
      set_dilation(0.6)
      setTimeout ->
        set_dilation(e)
      , 500

