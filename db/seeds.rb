action_type = ["follow", "unfollow", "was followed", "was unfollowed",
  "learn", "login", "create a category", "destroy a category",
  "edit a category", "create a word", "destroy a word", "edit a word"]
User.create! name: "tracthinh", email: "tracthinh@gmail.com",
  phone: "0123456789", address: "123 KeangNam", sex: true,
  password: "123456", password_confirmation: "123456", is_admin: true
User.create! name: "kieudang", email: "kieudang@gmail.com",
  phone: "9876543210", address: "123 KeangNam", sex: true,
  password: "123456", password_confirmation: "123456", is_admin: true
100.times{
  name = Faker::Name.name
  email = Faker::Internet.email
  phone = Faker::PhoneNumber.phone_number
  address = Faker::Address.street_address
  sex = Faker::Boolean.boolean
  password = "123456"
  User.create! name: name, email: email, phone: phone, address: address,
    sex: sex, password: password, password_confirmation: password
}
20.times{
  name = Faker::Name.title
  description = Faker::Hacker.say_something_smart
  category = Category.create! name: name, description: description
  Activity.create! action_type: 7, user_id: 1,
    target_id: category.id, content: action_type[6],
    link: "/categories/#{category.id}"
  20.times{
    content = Faker::Name.title
    category_id = Faker::Number.between 1, 20
    word = Word.create! content: content, category_id: category_id
    word_answers = word.word_answers.all
    Activity.create! action_type: 10, user_id: 1,
      target_id: word.id, content: action_type[9],
      link: "/categories/#{category_id}/words/#{word.id}"
    answer_content = Faker::Name::title
    is_correct = true
    word_answers[0].update_attributes! content: answer_content,
      is_correct: is_correct
    (1..3).each do |i|
      answer_content = Faker::Name::title
      is_correct = false
      word_answers[i].update_attributes! content: answer_content,
        is_correct: is_correct
    end
  }
}
Activity.create! action_type: 1, user_id: 2,
  target_id: 1, content: action_type[0],
  link: "/users/1"
Activity.create! action_type: 3, user_id: 1,
  target_id: 2, content: action_type[2],
  link: "/users/2"
