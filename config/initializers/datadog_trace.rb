require "ddtrace"
require "datadog/statsd"
require "net/http"

if ENV["AWS_EXECUTION_ENV"].present?
  Datadog.configure do |c|
    # Global settings
    c.tracing.transport_options = proc { |t|
      t.adapter :net_http, Net::HTTP.get(URI("http://169.254.169.254/latest/meta-data/local-ipv4")), 8126, timeout: 30
    }

    c.service = ENV["PROJECT_NAME"]
    c.tags = { app: ENV['PROJECT_NAME'] }
    c.env = ENV["ENVIRONMENT"]
    c.diagnostics.debug = false

    c.runtime_metrics.statsd = Datadog::Statsd.new socket_path: "var/run/datadog/dsd.socket"
    c.runtime_metrics.enabled = true
    
    # Tracing settings
    c.tracing.analytics.enabled = true
    c.tracing.partial_flush.enabled = true

    # Rails    
    c.tracing.instrument :rails,
          service_name: ENV['PROJECT_NAME'],
          controller_service: "#{ENV['PROJECT_NAME']}-controller",
          cache_service: "#{ENV['PROJECT_NAME']}-cache",
          database_service: "#{ENV['PROJECT_NAME']}-db"

    # Redis
    c.tracing.instrument :redis, service_name: "#{ENV['PROJECT_NAME']}-redis"

    # Sidekiq
    c.tracing.instrument :sidekiq, service_name: "#{ENV['PROJECT_NAME']}-sidekiq"

    # Net::HTTP
    c.tracing.instrument :http, service_name: "#{ENV['PROJECT_NAME']}-http"

    # skipping the health check: if it returns true, the trace is dropped
    Datadog::Tracing.before_flush(Datadog::Tracing::Pipeline::SpanFilter.new { |span|
      span.name == "rack.request" && span.get_tag("http.url") == "/monitors/lb"
    })
  end
end