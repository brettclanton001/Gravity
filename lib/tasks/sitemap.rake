namespace :sitemap do

  desc ""
  task ping: :environment do
    Rails.logger.info "Pinging Search Engines with the Sitemap URL"
    SitemapGenerator::Sitemap.default_host = 'http://gravityapp.co'
    SitemapGenerator::Sitemap.ping_search_engines
  end

end
