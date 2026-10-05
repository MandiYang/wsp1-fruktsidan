require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    # Funktion för att prata med databasen
    # Exempel på användning: db.execute('SELECT * FROM products')
    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    # Routen gör en redirect till '/fruits'
    get '/' do
        redirect('/fruits')
    end

    #Routen hämtar alla frukter i databasen
    get '/fruits' do
      @fruits = db.execute('SELECT * FROM products')
      ap @fruits
      erb(:"fruits/index")
    end

    # Routen visar ett formulär för att spara en ny frukt till databasen.
    get '/fruits/new' do
      @categories = db.execute('SELECT * FROM categories')
      erb(:"fruits/new")
    end

    # Routen sparar en frukt till databasen och gör en redirect till '/fruits'.
    post '/fruits' do
      ap params
      name = params["fruit_name"]
      description = params["fruit_description"]
      category_id = params["category_id"]

      db.execute("INSERT INTO products (name, description, category_id) VALUES(?,?,?)", [name, description, category_id])

      redirect("/fruits")
    end

    # Routen visar all info för frukten med id:t
    #
    # Fruktens kategori ligger i en annan tabell, så den hämtas med en
    # andra fråga. category_id i products pekar på id i categories.
    get '/fruits/:id' do | id |
      @fruit = db.execute('SELECT * FROM products WHERE id=?', id).first
      @category = db.execute('SELECT * FROM categories WHERE id=?', @fruit['category_id']).first
      ap @fruit
      ap @category
      erb(:"fruits/show")
    end

    # Routen tar bort frukten med id
    post '/fruits/:id/delete' do | id |
      db.execute("DELETE FROM products WHERE id =?", id)

      redirect("/fruits")
    end

    # Routen visar ett formulär på edit.erb med datan för frukten med id
    get '/fruits/:id/edit' do | id |
      ap "Hämtar info om frukten med id: #{id}"
      @fruit = db.execute('SELECT * FROM products WHERE id=?', id).first
      @categories = db.execute('SELECT * FROM categories')
      ap @fruit
      erb(:"fruits/edit")
    end

    # Routen sparar ändringarna från formuläret
    post "/fruits/:id/update" do | id |
      f_name = params["fruit_name"]
      f_description = params["fruit_description"]
      f_category_id = params["category_id"]

      sql = "UPDATE products SET name =?, description =?, category_id =? WHERE id =?"
      db.execute(sql, [f_name, f_description, f_category_id, id])

      redirect("/fruits")
    end

    # Routen hämtar alla kategorier i databasen
    get '/categories' do
      @categories = db.execute('SELECT * FROM categories')
      ap @categories
      erb(:"categories/index")
    end

    # Routen visar en kategori och frukterna som hör till den.
    #
    # Två frågor: en för kategorin, en för frukterna som pekar på den.
    get '/categories/:id' do | id |
      @category = db.execute('SELECT * FROM categories WHERE id=?', id).first
      @fruits = db.execute('SELECT * FROM products WHERE category_id=?', id)
      ap @category
      ap @fruits
      erb(:"categories/show")
    end

end
