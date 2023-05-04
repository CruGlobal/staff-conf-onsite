require "ddtrace"
require "datadog/statsd"
require "net/http"

if ENV["AWS_EXECUTION_ENV"].present?
  Datadog.configure do |c|
    # Tracer
    c.tracer hostname: Net::HTTP.get(URI("http://169.254.169.254/latest/meta-data/local-ipv4")),
             port: 8126,
             service: ENV["PROJECT_NAME"],
             tags: { app: ENV['PROJECT_NAME'] },
             debug: false,
             enabled: true,
             env: ENV["ENVIRONMENT"]

    # Rails
    c.use :rails,
          service_name: ENV['PROJECT_NAME'],
          controller_service: "#{ENV['PROJECT_NAME']}-controller",
          cache_service: "#{ENV['PROJECT_NAME']}-cache",
          database_service: "#{ENV['PROJECT_NAME']}-db"

    # Redis
    c.use :redis, service_name: "#{ENV['PROJECT_NAME']}-redis"

    # Sidekiq
    c.use :sidekiq, service_name: "#{ENV['PROJECT_NAME']}-sidekiq"

    # Net::HTTP
    c.use :http, service_name: "#{ENV['PROJECT_NAME']}-http"

    # skipping the health check: if it returns true, the trace is dropped
    Datadog::Pipeline.before_flush(Datadog::Pipeline::SpanFilter.new do |span|
      span.name == 'rack.request' && span.get_tag('http.url') == '/monitors/lb'
    end)
  end
end
