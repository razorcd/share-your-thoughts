# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :thought do
    title "Thought 1"
    body "Body thought 1"
  end
  factory :thought_strip, :class => Thought do
    title "  AAAA  "
    body "     Body   "
  end
end
