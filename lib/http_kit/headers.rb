require_relative "headers/common"
require_relative "headers/resolve"

module HTTPKit
  class Headers
    extend Resolve

    attr_accessor :custom_headers

    def initialize
      @custom_headers = {}
    end

    def accept! content_type
      handlers["Accept"].add_content_type content_type
    end

    def accept_charset! charset
      handlers["Accept-Charset"].add_charset charset
    end

    def [] name
      handlers[name]
    end

    def []= name, str
      if str.empty?
        handlers.delete name
      else
        handlers[name].assign str
      end
    end

    def copy
      instance = self.class.new
      handlers.each do |handler_cls_name, handler|
        instance.handlers[handler_cls_name] = handler.copy
      end
      instance.custom_headers = custom_headers.dup
      instance
    end

    def handlers
      @handlers ||= Hash.new do |hsh, header_name|
        handler = self.class.resolve header_name
        handler or raise ArgumentError, "Unknown header #{header_name.inspect}"
        hsh[header_name] = handler
      end
    end

    def remove_custom_header name
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