require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://gravityapp.co'
SitemapGenerator::Sitemap.create do

  add '/', :changefreq => 'daily', :priority => 0.9
  add '/home', :changefreq => 'daily', :priority => 0.9
  add '/pricing', :changefreq => 'weekly'
  add '/terms', :changefreq => 'weekly'
  add '/privacy', :changefreq => 'weekly'
  add '/users/sign_up', :changefreq => 'monthly'
  add '/users/sign_in', :changefreq => 'monthly'

end

# SitemapGenerator::Sitemap.ping_search_engines
