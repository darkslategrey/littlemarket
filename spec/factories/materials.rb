# coding: utf-8

FactoryGirl.define do

  factory :latex, :class => Material do
    name "LATEX"
    value "Latex"
  end

  factory :velour, :class => Material do
    name "VELOURSC"
    value "Velours Côtelé"
  end
  
end
