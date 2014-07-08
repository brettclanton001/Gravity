$ ->

  is_upload_page = $('body').hasClass 'is-upload-page'

  if is_upload_page

    window.dz_new_file = (file)->
      link = "<a href=\"#{file.url}\" target=\"_blank\">"
      text_link = "#{link}#{file.url}</a>"
      image_link = "#{link}<img src=\"#{file.thumbnail}\" /></a>"
      $('#uploads-page-file-list tbody.data').prepend "
        <tr>
          <td class=\"image\">#{image_link}</td>
          <td class=\"url\">#{text_link}</td>
          <td class=\"time\" data-time=\"#{file.created_at}\">just now</td>
        </tr>"

    window.dz_upload_progress = (percent)->
      if percent == 100
        $('.upload-page-spiral').removeClass 'fast'
      else
        $('.upload-page-spiral').addClass 'fast'

    update_times = ->
      $.each $('#uploads-page-file-list .time'), (i, td)->
        time = Date.parse $(td).attr('data-time')
        timeago = jQuery.timeago time
        $(td).text timeago

    setInterval ->
      update_times()
    , 30000
