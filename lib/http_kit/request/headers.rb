module HTTPKit
  class Request
    class Headers < Headers::Common
      define_header "Accept" do
        def initialize
          @value = []
        end

        def coerce str
          str.split %r{; ?}
        end

        def add_content_type content_type
          validate content_type
          value << content_type
        end

        def validate content_type
          unless content_type.match %r{\A.+/.+\Z}
            raise ArgumentError, "invalid content type #{content_type.inspect}"
          end
        end

        def serialized_value
          value * "; "
        end
      end

      define_header "Accept-Charset" do
        def initialize
          @value = []
        end

        def coerce str
          str.split %r{; ?}
        end

        def add_charset charset
          validate charset
          value << charset
        end

        def validate charset
          unless Encoding.find charset
            raise ArgumentError, "unknown charset #{charset.upcase.inspect}"
          end
        end

        def serialized_value
          value * "; "
        end
      end

      define_header "Host"
    end
  end
end
