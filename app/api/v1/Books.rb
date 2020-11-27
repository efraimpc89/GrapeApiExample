module V1
    class Books < Grape::API
        

        #GET

        desc  'Return all books'
        get '/books' do
            books = Book.all 
            present books
        end

        desc 'Return specific book'
        get  '/books/:id' do
            book = Book.find(params[:id])
            present book
        end

        #POST

        desc 'Creates a new book'
        params do
            requires :title,        type: String
            requires :description,  type: String
            requires :page_count,   type: Integer
        end
        post '/books' do
            book = Book.create!({
                title:  params[:title],
                description: params[:description],
                page_count: params[:page_count]
            })
        end

        #PUT

        desc 'Updates an specific book'
        params do
            requires :id,  type: Integer
            optional :title,        type: String
            optional :description,  type: String
            optional :page_count,   type: Integer
        end
        put '/books/:id' do
            book = Book.find(params[:id])
            raise NotFoundError if book.nil?

            Book.find(params[:id]).update_attributes!({
                title:  params[:title],
                description: params[:description],
                page_count: params[:page_count]
            })
        end

        #DELETE
        desc 'Deletes an specific book'
        params do
            requires :id,  type: Integer
        end
        delete '/books/:id' do
            book = Book.find(params[:id])
            raise NotFoundError if book.nil?

            Book.find(params[:id]).destroy
        end


    end
end