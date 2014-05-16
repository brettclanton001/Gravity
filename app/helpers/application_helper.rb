module ApplicationHelper

  def time_ago file
    "#{distance_of_time_in_words(Time.now, file.created_at)} ago"
  end

end
