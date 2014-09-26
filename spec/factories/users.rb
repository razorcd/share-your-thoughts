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

  factory :user2, :class => User do
    full_name "Full Seondname"
    username  "username2"
    password  "password2"
    password_confirmation  "password2"
    avatar  "/avatarts/username_av1.jpg"
    email "email2@ema.il"
  end
end
