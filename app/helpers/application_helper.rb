module ApplicationHelper

  def short_url file
    "#{request.protocol + request.host_with_port}/i/#{file.token}"
  end

  def time_ago file
    "#{distance_of_time_in_words(Time.now, file.created_at)} ago"
  end


end
