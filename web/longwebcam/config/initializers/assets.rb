# From http://theflyingdeveloper.com/controller-specific-assets-with-rails-4/
# (Also in Evernote)
%w( alpha cameras ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js", "#{controller}.css"]
end
