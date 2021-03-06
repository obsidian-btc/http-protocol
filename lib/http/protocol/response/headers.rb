module HTTP
  module Protocol
    class Response
      class Headers < Headers
        define_header "Etag" do
          def validate(etag)
            unless pattern.match etag
              raise Error.new "invalid etag #{etag.inspect}"
            end
          end

          def pattern
            %r{^(?:W/)?"?[!#-~\x80-\xFF]*"?$}n
          end
        end

        define_header "Keep-Alive" do
          def initialize
            @value = {}
          end

          def coerce(str)
            vals = str.split ","
            vals.each_with_object Hash.new do |val, hsh|
              unless %r{^(?<property>timeout|max)=(?<number>\d+)$} =~ val
                raise Error.new "invalid Keep-Alive #{str.inspect}"
              end
              hsh[property.to_sym] = number.to_i
            end
          end

          def timeout=(val)
            @value[:timeout] = val.to_i
          end

          def max=(val)
            @value[:max] = val.to_i
          end

          def serialized_value
            @value.map do |name, val| "#{name}=#{val}" end * ","
          end
        end

        define_header "Last-Modified" do
          def coerce(str)
            Time.httpdate str
          rescue ArgumentError => error
            raise Error.new error.message
          end

          def value
            @value.httpdate
          end
        end
      end
    end
  end
end
