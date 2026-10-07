require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    #TODO: Skriv routen hämtar alla frukter i databasen
    get "/fruits" do
      @fruits = db.execute('SELECT * FROM products ORDER BY name ASC')
      ap @fruits
      erb(:"fruits/index")
    end

    get '/fruits/new' do
      @categories = db.execute('SELECT * FROM categories')
      ap @categories
      erb(:"fruits/new")
    end

    get '/categories' do
      @categories = db.execute('SELECT * FROM categories')
      ap @categories
      erb(:"categories/index")
    end

    get '/categories/:id' do | id |
      @category = db.execute('SELECT * FROM categories 
                    WHERE id=?',
                    id).first
      @fruits = db.execute('SELECT * FROM products WHERE category_id=?', id)
      ap @category
      ap @fruits
      erb(:"categories/show")
    end

    get '/fruits/:id/edit' do | id |
      @categories = db.execute('SELECT * FROM categories')
      ap @categories
      ap id
      @fruit=db.execute("SELECT * FROM products WHERE id =?", id).first
      erb(:"fruits/edit")
    end


    get '/fruits/:id' do | id |
      @fruit = db.execute('SELECT * FROM products 
                  WHERE id=?', id).first
      @category = db.execute('SELECT * FROM categories 
                    WHERE id=?',
                    @fruit['category_id']).first
      ap @fruit
      ap @category
      erb(:"fruits/show")
    end

    # Routen tar bort frukten med id
    post '/fruits/:id/delete' do | id |
      db.execute("DELETE FROM products WHERE id =?", id)
      redirect("/fruits")
    end

    post '/fruits' do
      ap params
      f_name = params["fruit_name"]
      f_description = params["fruit_description"]
      f_tastiness = params["fruit_tastiness"]
      f_price = params["fruit_price"]
      f_category_id=params["category_id"]
      db.execute("INSERT INTO products (name, tastiness, description, price, category_id) VALUES (?, ?, ?, ?, ?)", [f_name, f_tastiness, f_description, f_price, f_category_id])
      redirect("/fruits")
    end

    post "/fruits/:id/update" do | id |
      f_name = params["fruit_name"]
      f_description = params["fruit_description"]
      f_category_id=params["category_id"]

      db.execute("UPDATE products SET name =?, description=?, category_id=? WHERE id =?", [f_name, f_description, f_category_id, id])

      redirect("/fruits")
    end
end