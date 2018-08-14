require 'pry-byebug'
require_relative 'models/bounty'

Bounty.delete_all

bounty1 = Bounty.new({
  'name' => 'Blankor',
  'species' => 'Space Monkey',
  'favourite_weapon' => 'Banana',
  'bounty_value' => '200'
})

bounty2 = Bounty.new({
  'name' => 'BadMan',
  'species' => 'Human',
  'favourite_weapon' => 'Wrench',
  'bounty_value' => '100'
})

bounty1.save
bounty2.save

binding.pry
nil
