
require_relative "store"
require_relative "scraper"
require 'pry'
require 'csv'


#films_info is an array of arrays
headers = ["Rank", "Title", "Genre", "Description", "Director", "Actors", "Year", "Runtime (Minutes)", "Rating", "Votes", "Revenue (Millions)", "Metascore"]

c = CSV.open("TEST", "w")
#csv << headers
  c << headers