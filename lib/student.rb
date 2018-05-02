require_relative "../config/environment.rb"

class Student
	
	attr_accessor :name, :grade
	attr_reader :id

	def initialize(id=nil, name, grade)
		@id, @name, @grade = id, name, grade
	end

	def self.create_table
		sql = <<-SQL
			create table if not exists students (
				id INTEGER PRIMARY KEY,
				name TEXT, 
				grade TEXT)
		SQL
		DB[:conn].execute(sql)
	end

	def self.drop_table
		sql = "DROP TABLE students"
		DB[:conn].execute(sql)
	end

	def self.create(name, grade)
		s = Student.new(name, grade)
		s.save
		s
	end

	def self.new_from_db(row)
		s = Student.new(row[0], row[1], row[2])
	end

	def self.find_by_name(name)
		sql = "SELECT * FROM students where name = ?"
		row = DB[:conn].execute(sql, name)[0]
		Student.new_from_db(row)
	end

	def save
		if self.id.nil?
			sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
			DB[:conn].execute(sql, self.name, self.grade)
			sql = "SELECT last_insert_rowid() FROM students"
			@id = DB[:conn].execute(sql)[0][0]
		else
			self.update
		end
	end

	def update
		sql = "UPDATE students SET name = ?, grade = ? where id = ?"
		DB[:conn].execute(sql, self.name, self.grade, self.id)
	end

end

