module HTTP
  module Protocol
    class Headers
      extend DefineHeader
      extend Resolve
      include Common

      attr_accessor :custom_headers

      dependency :logger, Telemetry::Logger

      def self.build
        instance = new
        Telemetry::Logger.configure instance
        instance
      end

      def initialize
        @custom_headers = {}
      end

      def accept!(content_type)
        handlers["Accept"].add_content_type content_type
      end

      def accept_charset!(charset)
        handlers["Accept-Charset"].add_charset charset
      end

      def [](name)
        handlers[name].serialized_value
      end

      def []=(name, str)
        if str.nil?
          handlers.delete name
        else
          handlers[name].assign str
        end
      end

      def handlers
        @handlers ||= Hash.new do |hsh, header_name|
          handler = self.class.resolve header_name
          hsh[header_name] = handler
        end
      end

      def inspect
        handlers.reduce String.new do |str, (_, handler)|
          str << handler.to_s
        end
      end

      def merge(other_headers)
        instance = self.class.build
        instance.merge! self
        instance.merge! other_headers
        instance
      end

      def merge!(other_headers)
        logger.opt_trace "Merging headers"
        logger.opt_data other_headers
        other_headers.handlers.each do |header_name, handler|
          handlers[header_name] = handler.copy
        end
        logger.opt_debug "Headers merged"
        logger.opt_data self
      end

      def remove_custom_header(name)
        custom_headers.delete name
      end

      def to_s
        str = ""
        handlers.each do |_, handler| str << handler.to_s end
        custom_headers.each do |name, value| str << "#{name}: #{value}\r\n" end
        str
      end
    end
  end
end
