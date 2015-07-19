require 'rails_helper'

RSpec.describe LittleMarketCreation, type: :model do
  creations = LittleMarketCreation.all
  expect(creations).to be_a Array
  # pending "add some examples to (or delete) #{__FILE__}"
end
