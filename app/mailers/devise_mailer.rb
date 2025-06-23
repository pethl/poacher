class DeviseMailer < Devise::Mailer
  helper :application # gives access to app/helpers/application_helper.rb
  include Devise::Controllers::UrlHelpers # lets you use Devise URL helpers
  default template_path: 'devise/mailer' # ensures it uses the default Devise mail views

  layout 'mailer' # ✅ tells Devise to use your custom mailer.html.erb layout
end
