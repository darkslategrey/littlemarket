FactoryGirl.define do

  factory :lucien, :class => User do
    username "lucien.farstein@gmail.com"
    password "toto555500"
    check_little_ids false
  end

end
