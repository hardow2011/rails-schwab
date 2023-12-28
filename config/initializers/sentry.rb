unless Rails.env.development?
  Sentry.init do |config|
    config.dsn = 'https://a9feaf8e6fb9402cd5672d84840de822@o4506474750869504.ingest.sentry.io/4506474753490944'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 1.0
    # or
    # config.traces_sampler = lambda do |context|
    #   true
    # end
  end
end