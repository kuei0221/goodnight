# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(
  [
    { id: 1, name: 'michael' },
    { id: 2, name: 'ivy' },
    { id: 3, name: 'yoyo' }
  ]
)

(1..3).each do |n|
  Sleep.create(
    [
      { user_id: n, start_at: (n + 1).day.ago, end_at: n.day.ago },
      { user_id: n, start_at: (n + 3).day.ago, end_at: (n + 2).day.ago }
    ]
  )
end
