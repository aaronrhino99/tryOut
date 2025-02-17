# config/initializers/sidekiq.rb
require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    namespace: "#{Rails.application.class.module_parent_name}_#{Rails.env}"
  }

  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 5
  end

  config.concurrency = ENV.fetch('SIDEKIQ_CONCURRENCY', 25).to_i

  config.error_handlers << Proc.new do |ex, ctx|
    Rails.logger.error "[Sidekiq] Error: #{ex.message}\n#{ex.backtrace.join("\n")}"
  end

  config.reliable_fetch!
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
    namespace: "#{Rails.application.class.module_parent_name}_#{Rails.env}"
  }

  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::UniqueJobs
  end
end

Sidekiq::Logging.logger = Rails.logger

Sidekiq.default_worker_options = {
  retry: 5,
  backtrace: Rails.env.development? ? true : 5
}

if Rails.env.production?
  Sidekiq.logger.level = Logger::WARN
  Sidekiq.strict_args!
end