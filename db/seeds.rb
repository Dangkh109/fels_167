User.create!(name: "tracthinh", email: "tracthinh@gmail.com",
   phone: "0123456789", address: "123 KeangNam", sex: true,
   password: "123456", password_confirmation: "123456", is_admin: true)
 User.create!(name: "kieudang", email: "kieudang@gmail.com",
   phone: "9876543210", address: "123 KeangNam", sex: true,
   password: "123456", password_confirmation: "123456", is_admin: true)
 100.times{
   name = Faker::Name.name
   email = Faker::Internet.email
   phone = Faker::PhoneNumber.phone_number
   address = Faker::Address.street_address
   sex = Faker::Boolean.boolean
   password = "123456"
   User.create!(name: name, email: email, phone: phone, address: address,
     sex: sex, password: password, password_confirmation: password)
 }
