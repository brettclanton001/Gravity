$ ->
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

  update_times = ->
    $.each $('#uploads-page-file-list .time'), (i, td)->
      time = Date.parse $(td).attr('data-time')
      timeago = jQuery.timeago time
      $(td).text timeago

  setInterval ->
    update_times()
  , 30000
