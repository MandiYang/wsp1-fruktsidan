require 'sqlite3'
require_relative '../config'

db = SQLite3::Database.new(DB_PATH)

puts "Använder databasen: #{DB_PATH}"
puts "🧹 Tar bort gamla tabeller..."
db.execute('DROP TABLE IF EXISTS products')
db.execute('DROP TABLE IF EXISTS categories')

puts "🧱 Skapar tabeller..."
db.execute('CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT)')

db.execute('CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            tastiness INTEGER,
            description TEXT,
            category_id INTEGER)')

puts "🗂️  Fyller på med kategorier..."
db.execute('INSERT INTO categories (name, description) VALUES ("Kärnfrukt", "Frukter med kärnhus i mitten.")')        #category_id = 1
db.execute('INSERT INTO categories (name, description) VALUES ("Stenfrukt", "Frukter med en enda hård kärna.")')      #category_id = 2
db.execute('INSERT INTO categories (name, description) VALUES ("Citrus",    "Syrliga frukter med tjockt skal.")')     #category_id = 3
db.execute('INSERT INTO categories (name, description) VALUES ("Bär",       "Små frukter som ofta växer i klasar.")') #category_id = 4

puts "🍎 Fyller på med frukter..."
# category_id 1 = Kärnfrukt
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Äpple",         7, "En rund frukt som finns i många olika färger.", 1)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Päron",         6, "En nästan rund, men lite avlång, frukt.", 1)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Kvitten",       4, "Hård och syrlig. Kokas oftast innan den äts.", 1)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Nashipäron",    7, "Knastrigt och väldigt saftigt.", 1)')

# category_id 2 = Stenfrukt
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Persika",       8, "Luddigt skal och en stor kärna.", 2)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Plommon",       7, "Liten och söt, blå eller gul.", 2)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Körsbär",       9, "Små och röda. Växer ofta i par.", 2)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Aprikos",       7, "Orange och mjuk.", 2)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Nektarin",      8, "Som en persika, fast med slätt skal.", 2)')

# category_id 3 = Citrus
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Apelsin",       8, "Saftig och lätt att skala.", 3)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Citron",        3, "Mycket sur. Används mest i matlagning.", 3)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Lime",          3, "Mindre och grönare än en citron.", 3)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Grapefrukt",    5, "Stor och beskt syrlig.", 3)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Mandarin",      8, "En liten apelsin utan kärnor.", 3)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Klementin",     9, "Söt och mycket lätt att skala.", 3)')

# category_id 4 = Bär
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Jordgubbe",    10, "Röd, med kärnorna på utsidan.", 4)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Blåbär",        9, "Små och blå. Växer i skogen.", 4)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Hallon",        9, "Mjukt och ihåligt i mitten.", 4)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Björnbär",      7, "Svart och växer på en taggig buske.", 4)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Vinbär",        6, "Små klasar, röda eller svarta.", 4)')
db.execute('INSERT INTO products (name, tastiness, description, category_id) VALUES ("Krusbär",       5, "Grön och syrlig.", 4)')

puts "✅ Databasen är seedad!"
