# config/initializers/sidekiq.rb
require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    namespace: "#{Rails.application.class.module_parent_name}_#{Rails.env}"
  }

  config.concurrency = ENV.fetch('SIDEKIQ_CONCURRENCY', 25).to_i
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    namespace: "#{Rails.application.class.module_parent_name}_#{Rails.env}"
  }
end

# Updated configuration syntax
Sidekiq.default_job_options = {  # Changed from default_worker_options
  retry: 5,
  backtrace: Rails.env.development? ? true : 5
}