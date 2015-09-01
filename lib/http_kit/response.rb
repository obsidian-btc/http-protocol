module HTTPKit
  class Response < Message
    require_relative "response/headers"

    def self.build
      headers = Headers.new
      new headers
    end

    STATUS_LINE_REGEX = %r{^HTTP\/1\.1 (?<status>\d+ [\w\s]+?)\s*\r$}

    attr_reader :headers
    attr_reader :state
    attr_reader :status_message

    def initialize headers
      @headers = headers
      @state = :initial
    end

    def [] name
      headers[name]
    end

    def []= name, value
      headers[name] = value
    end

    def << data
      data.each_line do |line|
        case state
        when :initial then
          self.status_line = line
          @state = :headers
        when :headers then
          if line == HTTPKit.newline
            headers.freeze
            @state = :in_body
          else
            _, header, value = HEADER_REGEX.match(line).to_a
            headers[header].assign value
          end
        when :in_body then fail "tried to read body"
        end
      end
    end

    def in_body?
      state == :in_body
    end

    def status= str
      @status_code, @status_message = str.split " ", 2
    end

    def status
      "#{status_code} #{status_message}"
    end

    def status_code
      @status_code.to_i
    end

    def status_line= line
      _, status = STATUS_LINE_REGEX.match(line).to_a
      raise ProtocolError.new "expected status line, not #{line.inspect}" unless status
      self.status = status
    end

    def status_line
      "HTTP/1.1 #{status}"
    end

    def to_s
      [status_line, headers].join
    end
  end
end
