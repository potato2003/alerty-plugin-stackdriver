require 'alerty'
require "google/cloud/logging"

class Alerty
  class Plugin
    class Stackdriver

      DEFAULT_NUM_OF_RETIRES = 3

      def initialize(config)
        # https://cloud.google.com/logging/docs/api/v2/resource-list
        @resource_type   = config.resource_type
        @resource_labels = config.resource_labels
        @app_name        = config.app_name    || 'alerty'
        @app_version     = config.app_version || 'default'
        @log_name        = config.log_name    || 'alerty'
        @message         = config.message
        @num_retries     = config.num_retries || DEFAULT_NUM_OF_RETIRES

        @stackdriver = Google::Cloud::Logging.new(
          project_id: config.project_id,
          keyfile:    config.keyfile ? ensure_keyfile(config.keyfile) : nil
        )
      end

      def alert(record)
        entry = make_entry(record)

        retrable(tries: @num_retries) do
          @stackdriver.write_entries(entry)
          Alerty.logger.info "Sent #{{log_entry: entry.inspect}} to #{@log_name}"
        end
      end

    private
      def retrable(options = {}, &block)
        tries = options[:tries] || DEFAULT_NUM_OF_RETIRES

        retries = 0
        begin
          yield
        rescue => e
          retries += 1
          sleep 1
          if retries <= tries
            retry
          else
            raise e
          end
        end
      end

      def make_entry(record)
        e = @stackdriver.entry

        e.resource.type   = @resource_type
        e.resource.labels = @resource_labels if @resource_labels
        e.log_name        = @log_name
        e.payload         = payload(record)
        e.severity        = :ERROR

        e
      end

      def payload(record)
        body = if @message
                 expand_placeholder(@message, record)
               else
                 record[:output]
               end

        # support Stackdriver Error Reporting. https://cloud.google.com/error-reporting/docs/formatting-error-messages
        {
          serviceContext: {
            service: @app_name,
            app_version: @app_version
          },
          message: body,
          context: {
            functionName: record[:command],
            lineNumber: 0
          }
        }
      end

      def expand_placeholder(str, record)
        replaced = str.gsub('${command}', record[:command])
        replaced.gsub!('${hostname}', record[:hostname])
        replaced.gsub!('${output}', record[:output])
        replaced
      end

      def ensure_keyfile(v)
        if v.is_a?(String)
          v
        elsif v.is_a?(Hash)
          JSON.parse(v['content'])
        end
      end
    end
  end
end
