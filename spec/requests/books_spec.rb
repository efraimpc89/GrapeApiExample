require 'rails_helper'
require 'factory_bot_rails' 
require 'faker'

describe "TEST API" do
   
    it 'GET book request - response status 200' do
        get('/api/v1/books')
        expect(response.status).to eq(200)
    end

    # it 'GET - /googleapi/search' do
    #     get('/googleapi/search')

    #     puts response.status

    #     #expect(response.status).to eq(200)
    # end

    it 'get book request - returns books ' do
          
        FactoryBot.create(:book, 
            title:          Faker::Book.title ,
            description:    Faker::Lorem.paragraph,
            page_count:     Faker::Number.between(from: 100, to: 5000),
            publisher_id:   FactoryBot.create(:publisher, name: Faker::Book.publisher).id,
            category:       [ 
                                FactoryBot.create(:category, name: Faker::Book.genre), 
                                FactoryBot.create(:category, name: Faker::Book.genre)
                            ]
        )
        
        get('/api/v1/books/1')

        parsed_response = JSON.parse(response.body)

        expect(parsed_response).not_to be_empty

    end

    it 'POST - Create book' do

        post'/api/v1/books/',  params:{
            title:          Faker::Book.title, 
            description:    Faker::Lorem.paragraph, 
            page_count:     Faker::Number.between(from: 100, to: 5000),  
            publisher_id:   FactoryBot.create(:publisher, name: Faker::Book.publisher).id, 
            categories:     [FactoryBot.create(:category, name: Faker::Book.genre)]
        }
        
        expect(response.status).to eq(201)

    end

    it 'PUT - Update book' do

        post'/api/v1/books/',  params:{
            title:          Faker::Book.title, 
            description:    Faker::Lorem.paragraph, 
            page_count:     Faker::Number.between(from: 100, to: 5000),  
            publisher_id:   FactoryBot.create(:publisher, name: Faker::Book.publisher).id, 
            categories:     [FactoryBot.create(:category, name: Faker::Book.genre)]
        }
        
        expect(response.status).to eq(201)

        put '/api/v1/books/1',  params:{
            book: {
                title: "Test",
                description: Faker::Lorem.paragraph,
                page_count: Faker::Number.between(from: 100, to: 5000)
            },
            publisher: {
                name: Faker::Book.title
            },
            categories: [FactoryBot.create(:category, name: Faker::Book.genre)]
        }

        parsed_response = JSON.parse(response.body)

        expect(parsed_response['title']).to eq('Test')

    end

    it 'DELETE - book' do
        FactoryBot.create(:book, 
            title:          Faker::Book.title ,
            description:    Faker::Lorem.paragraph,
            page_count:     Faker::Number.between(from: 100, to: 5000),
            publisher_id:   FactoryBot.create(:publisher, name: Faker::Book.publisher).id,
            category:       [ 
                                FactoryBot.create(:category, name: Faker::Book.genre), 
                                FactoryBot.create(:category, name: Faker::Book.genre)
                            ]
        )

        delete('/api/v1/books/1')

        expect(response.status).to eq(200)
    end
end