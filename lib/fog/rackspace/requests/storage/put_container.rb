module Fog
  module Rackspace
    class Storage
      class Real
        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # @raise [Fog::Rackspace::Storage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Storage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Storage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Storage::ServiceError]
        def put_container(name, options={})
          if name =~ /\//
            raise Fog::Errors::Error.new('Folder names cannot include "/".')
          else
            request(
              :expects  => [201, 202],
              :method   => 'PUT',
              :headers => options,
              :path     => Fog::Rackspace.escape(name)
            )
          end
        end
      end

      class Mock
        def put_container(name, options={})
          existed = ! mock_container(name).nil?
          container = add_container(name)
          options.keys.each do |k|
            container.meta[k] = options[k].to_s if k =~ /^X-Container-Meta/
          end

          response = Excon::Response.new
          response.status = existed ? 202 : 201
          response
        end
      end
    end
  end
end
