class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize(student_hash)
    student_hash.each do |attribute, value| #{:name=>"Sophie DeBenedetto", :location=>"Brooklyn, NY"}
      self.send("#{attribute}=", value)#like a setter attribute=
    end
    @@all << self
    #binding.pry
  end

  def self.create_from_collection(students_array)
    #binding.pry
    students_array.each do |hash|
      Student.new(hash)
    end
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |att, value|
       self.send("#{att}=", value)
    end
    self
  end

  def self.all
    @@all
  end
end
