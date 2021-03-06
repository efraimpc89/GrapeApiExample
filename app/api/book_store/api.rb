module BookStore
    class API < Grape::API

        prefix :api
        format :json
        version 'v1', :path

        mount BookStore::V1::Books
    end
end