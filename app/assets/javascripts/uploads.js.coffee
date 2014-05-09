$ ->
  window.dz_new_file = (file)->
    link = "<a href=\"#{file.url}\" target=\"_blank\">#{file.url}</a>"
    $('#uploads-page-file-list tbody.data').prepend "<tr><td>#{link}</td><td>just now</td></tr>"
