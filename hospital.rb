# Release 0:
# Create patient and various employee objects.
# Classes:
#  Hospitals: (name, employees, patients)
#
# People: (age, sex, hospital)
# |\Patients (insurance ID)
# Employees  (tax ID)
#
# Release 1:
#User stories
# Auth codes: First letter R = Read, W = Write
# Second letters: EN: employee Name, ES: Employee salary, PN: Patient Name, MH: Medical History
# Admin: WEN, WES, RPN
# Doctor: REN, WPN, WMH
# Janitor: REN
# Patient: REN, WPN, RMH
require 'io/console'

class Hospital
  attr_reader :name, :location, :employees, :patients, :authenticated_users

  def initialize(details = { })
    @name = details.fetch(:name, "Generic")
    @location = details.fetch(:location, "Earth")
    @employee_list = []
#    @employee_database = {name: [ Person_object, salary ] }
    @patient_list = []
    @full_list = @employee_list + @patient_list
    @hospital_records = {name: "record" }
    @employee_name = {name: "My Name" }
    @employee_salary = { }
    @authenticated_users = []
    @role_permission_map = { "Admin"=> %w[WEN REN RES WES RPN],
                            "Doctor"=> %w[REN RPN WPN WMH RMH],
                           "Janitor"=> %w[REN],
                           "Patient"=> %w[RPN WPN REN RMH] }
  end

  def add(person)
    if person.role == "Patient"
      @patient_list << person
    else
      @employee_list << person
    end
  end

  def inpatient?(patient_name)
    @patient_list.each do |patient|
      return true if patient.name == patient_name
    end
      false
  end
  def login(person)  #person object
    puts "Hello #{person.name}"
    print "Password?\n"
    password = STDIN.noecho(&:gets).chomp
    if password == person.password
      @authenticated_users << person
      puts "\n#{person.name} is logged in\n"
    else
      "Invalid login"
    end
  end
  def menu(person)
    access_options = @role_permission_map[person.role]
    options = {}
    options[:wen] = " Edit Employee Database" if access_options.include?("WEN")
    options[:ren] = " View Employee Database" if access_options.include?("REN")
    options[:wes] = " Edit Employee Salary" if access_options.include?("WES")
    options[:res] = " View Employee Salary" if access_options.include?("RES")
    options[:wpn] = " Edit Patient Database" if access_options.include?("WPN")
    options[:rpn] = " View Patient Database" if access_options.include?("RPN")
    options[:wmh] = " Edit Patient Medical Record" if access_options.include?("WMH")
    options[:rmh] = " View Patient Medical History" if access_options.include?("RMH")
    options.each_pair { |key, value| puts "type: #{key} to #{value}. "}
    response = gets.chomp
    puts "You entered #{response}"
  end

end

class People
  attr_reader :sex, :age, :name, :role, :password
  def initialize(details = {} )
    @sex = details.fetch(:sex, "NS")
    @age = details.fetch(:age, nil)
    @name = details.fetch(:name, "John Doe")
    @role = details.fetch(:role, "Patient")
    @auth_codes = [] #based on role
    @password = details.fetch(:password, "password1")
    #roles = Doctor, Nurse, Janitor, Patient
  end
end

class Employees < People
  attr_reader :role, :employee_id
  def initialize(details = {} )
    super
    @role = details.fetch(:role, "NS")
    @employee_id = details.fetch(:employee_id, "NS")
  end
end

class Patients < People
  attr_reader :insurance_id
  def initialize(details = {} )
    super
    @insurance_id = details.fetch(:insurance_id, "NS")
  end

end


timmy = Patients.new( { name:"timmy",
                       sex:"M",
                       age: 25,
                       role: "Patient",
                       insurance_id: 12345,
                       password: "let me in" } )
# justin = Employees.new( { name:"justin",
#                        sex:"M",
#                        age: 37,
#                        role: "Doctor",
#                        employee_id: 12347,
#                        password: "xx" } )
#p timmy.inspect
hospital = Hospital.new( { name: "Cedar Sinai" , location: "NYC baby" } )
#p hospital.inspect
hospital.add(timmy)
p hospital.inpatient?("timmy")
p timmy.name
hospital.login(timmy)    #will prompt for password
hospital.authenticated_users.each {|x|  puts "#{x} Authenticated"}
#puts "Authenticated Users: #{hospital.authenticated_users}"
hospital.menu(timmy)
#hospital.read_record()
#puts timmy
#emps = File.open('employees.rb')
#emps.each do |line|
#  emp = eval(line)
#  puts emp.inspect
#  puts emp.class
#  Employees.new(emp)
#  hospital.add(emp)
  #puts eval(line)
#end
#Employees.new( { name: "ruben", sex: "M", age: 25, role: "Janitor", employee_id: 85545, password: "xx" } )

