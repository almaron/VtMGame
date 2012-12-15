options = YAML.load_file(Rails.root.join("config","mailer.yml"))[Rails.env]

ActionMailer::Base.smtp_settings = options['smtp'].symbolize_keys
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.default_url_options[:host] = options['host']
ActionMailer::Base.raise_delivery_errors = true if Rails.env.development?

require 'development_mail_interceptor'
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?