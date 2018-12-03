# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
Mission.destroy_all

10.times do
    Mission.create!(
        name: Faker::GreekPhilosophers.name,
        description: Faker::Food.dish,
        due_date: Faker::Date.forward(20),
        member: Faker::DrWho.character,
        author: Faker::Artist.name
    )
end

end

