namespace :ror do
  desc "ping app homepage"
  task ping: :environment do
    uri = URI.parse('http://gravityapp.co/')
    Net::HTTP.get(uri)
  end
end
