Sentry.init do |config|
  config.dsn = 'https://34636f5f706841a2ad0a17fa13c03caa@o415806.ingest.sentry.io/5956006'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  # config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |sampling_context|
    # transaction_context is the transaction object in hash form
    # keep in mind that sampling happens right after the transaction is initialized
    # for example, at the beginning of the request
    transaction_context = sampling_context[:transaction_context]

    # transaction_context helps you sample transactions with more sophistication
    # for example, you can provide different sample rates based on the operation or name
    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    case op
    when /request/
      case transaction_name
      when /healthcheck/
        0.0 # ignore healthcheck requests
      when /master_podcasts/
        0.0 # ignore healthcheck requests
      else
        0.5
      end
    when /sidekiq/
      0.01
    else
      0.0 # ignore all other transactions
    end
  end
end
