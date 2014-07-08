$ ->

  is_homepage = $('body').hasClass 'is-homepage'
  file_given = false

  if is_homepage

    window.dz_new_file = (file)->
      link = "<a href=\"#{file.url}\" target=\"_blank\">"
      text_link = "#{link}#{file.url}</a>"
      image_link = "#{link}<img src=\"#{file.thumbnail}\" /></a>"
      $('#homepage-file-list tbody.data .loading-spinner').remove()
      $('#homepage-file-list tbody.data').prepend "
        <tr>
          <td class=\"image\">#{image_link}</td>
          <td class=\"url\">#{text_link}</td>
          <td class=\"time\" data-time=\"#{file.created_at}\">just now</td>
        </tr>"

    window.dz_upload_progress = (percent)->
      if !file_given
        file_given = true
        $('.homepage-section.history').css
          minHeight: $('.homepage-section.history').height()
        $('#homepage-file-list tbody.data').html '<tr class="loading-spinner"><td><i class="icon-spinner icon-spin icon-large"></i></td></tr>'

      $('html, body').animate
        scrollTop: $(window).height()

      update_times = ->
        $.each $('#homepage-file-list .time'), (i, td)->
          time = Date.parse $(td).attr('data-time')
          timeago = jQuery.timeago time
          $(td).text timeago

      setInterval ->
        update_times()
      , 30000
