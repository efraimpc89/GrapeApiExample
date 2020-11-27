class API < Grape::API

    prefix :api
    format :json
    version 'v1', :path

    mount V1::Books
end