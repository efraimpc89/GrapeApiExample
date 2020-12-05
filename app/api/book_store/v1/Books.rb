module BookStore
    module V1
        class Books < Grape::API
            #format:json

            #GET

            desc  'Return all books'
                get '/books' do
                    books = Book.all             
                    present books, with: BookStore::Entities::Book
                end

            desc  'Return all publishers'
                get '/publishers' do
                    publishers = Publisher.all 
                    present publishers
                end

            desc 'Return specific book'
                get  '/books/:id' do
                    book = Book.find(params[:id])
                    present book, with: BookStore::Entities::Book
                end

            desc 'query for specific book in google book api'
                params do
                    requires :q,        type: String
                end
                get  '/googleapi/search' do
                    url = "https://www.googleapis.com/books/v1/volumes?q=#{params[:q]}&maxResults=15"
                    response = HTTParty.get(url)
                    result = response.parsed_response
                    present result
                end

            #POST

            desc 'Creates a new book'
                post '/books' do
                #Creates a new book
                book = Book.new(params[:book])
                
                #If publisher does not exist creates it
                publisher = Publisher.find_or_create_by(params[:publisher])
                book.publisher_id = publisher.id

                #Get categories,create them if they dont exist and assign them to book
                categories = params[:categories]
                categories.each do |c| 
                book.category << Category.find_or_create_by(name: c)
                end

                #save and present book
                book.save
                present book, with: BookStore::Entities::Book
                end


            desc 'Creates a publisher'
                params do
                    requires :name,        type: String
                end
                post '/publishers' do
                    publisher = Publisher.find_or_initialize_by({
                        name: params[:name]
                    })
                    publisher.save
                end 

            #PUT

            desc 'Updates an specific book'
                params do
                    requires :id,  type: Integer
                end
                put '/books/:id' do
                    #look for the existing book
                    book = Book.find(params[:id])

                    #Deletes any categories it already has
                    book.category.delete_all

                    # #Updates publisher
                    publisher = Publisher.find_or_create_by(params[:publisher])
                    Rails.logger.debug(publisher)
                    book.publisher_id = publisher.id

                    # #Updates main fields
                    book.update!(params[:book])

                    # #Updates categories
                    categories = params[:categories]
                    categories.each do |c| 
                    book.category << Category.find_or_create_by(name: c)
                    end

                    book.save!
                    present book, with: BookStore::Entities::Book

                end

            #DELETE
            desc 'Deletes an specific book'
                params do
                    requires :id,  type: Integer
                end
                delete '/books/:id' do
                    book = Book.find(params[:id])

                    #Deletes any categories it already has
                    book.category.delete_all

                    Book.find(params[:id]).destroy
                    #book.save
                end


        end
    end
end