# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# rubocop:disable Rails/Output

year = if ENV['YEAR'].present?
         ENV['YEAR'].split(',').map(&:to_i)
       else
         GenronSF::Term.latest.year
       end
puts "Target year: #{year}"
Array(year).each { |y| Term.find_or_create_by!(year: y) }

puts 'Importing kadais...'
ImportKadaisJob.perform_now(year: year)

puts 'Importing students...'
ImportStudentsJob.perform_now(year: year)

puts 'Importing works...'
ImportWorksJob.perform_now(kadais: Kadai.all)

# rubocop:enable Rails/Output
