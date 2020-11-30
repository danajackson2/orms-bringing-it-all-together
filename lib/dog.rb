require 'pry'
class Dog
    attr_accessor :name, :breed
    attr_reader :id
    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        sql = "CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"
        DB[:conn].execute(sql)
    end

    def self.drop_table
        DB[:conn].execute("DROP TABLE dogs")
    end

    def self.create(data)
        new_dog = Dog.new(name: data[:name], breed: data[:breed])
        new_dog.save
    end

    def update
        sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    end

    def save
        sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.breed)
        self
    end

    def self.new_from_db(data)
        new_dog = Dog.new(id: data[0], name: data[1], breed: data[2])
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM dogs WHERE id = ?"
        DB[:conn].execute(sql, id).map{|dog| self.new_from_db(dog)}[0]
    end

    def self.find_or_create_by(x)
        if !self.find_by_name(x[:name])  
            new_dog = Dog.create(x)
            new_dog.save
        else
            self.find_by_name(x[:name])
        end
    end

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name = ?"
        DB[:conn].execute(sql, name).map{|dog| self.new_from_db(dog)}[0]
    end
end