
if Rails.env == 'development'

  DOMAIN        = 'localhost:3000'
  SHORT_DOMAIN  = 'localhost:3000'

elsif Rails.env == 'test'

  DOMAIN        = 'localhost:3000'
  SHORT_DOMAIN  = 'localhost:3000'

else

  DOMAIN        = 'gravityapp.co'
  SHORT_DOMAIN  = 'gvty.co'

end
