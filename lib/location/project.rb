require_relative "store"
require 'pry'
require 'csv'

class Project
    attr_accessor :fileName

    def csv_expo
        c = CSV.open("#{@fileName}.csv", "w")
        c << ["IDnum", "Address", "City", "State", "ZIP"]
        Store.all.each do |loc|
            c << [loc.idnum, loc.address, loc.city, loc.state, loc.zip]
        end
        c.close()
    end

end

gary = Scraper.new("https://storefound.org/do-it-best-store-hours-locations","Do-it-best-test")
gary.scrape

