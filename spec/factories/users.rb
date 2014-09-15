# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    full_name "Full Name"
    username  "username"
    password  "password"
    password_confirmation  "password"
    avatar  "/avatarts/username_av1.jpg"
    email "email@ema.il"
  end

  factory :user_strip, :class => User do
    full_name "  Full Name  "
    username  "  username  "
    password  "password"
    password_confirmation  "password"
    avatar  "/avatarts/username_av1.jpg"
    email "   email@ema.il  "
  end

    factory :user_nopassword , :class => User do
    full_name "Full Name"
    username  "username"
    avatar  "/avatarts/username_av1.jpg"
    email "email@ema.il"
  end

end
