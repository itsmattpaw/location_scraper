# frozen_string_literal: true

require_relative "./store"
require_relative "./export"
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

class Scraper
  attr_accessor :link, :base, :state_pages, :city_pages, :loc_pages, :name

  def initialize(url,base)
    @link = url
    @base = base
    @state_pages = []
    @city_pages = []
    @loc_pages = []
  end

  def self.scrape(link,base,name)
    a = Scraper.new(link,base)
    a.page_scrape_for_link(link)
    a.linked_pages_scrape
    #a.linked_pages_scrape_single_test
    a.create_stores
    a.csv_expo(name)
  end

  def page_scrape_for_link(link)
    #finds additional links to follow and sorts into arrays
    doc = Nokogiri::HTML5(URI.open(link))
    doc.css(".main-block a").each do |lk|
      j = lk.attribute("href").text
      case j.split("/").length
      when 3
        @state_pages << j
      when 4
        @city_pages << j
      when 5
        @loc_pages << j
      end
      @state_pages.uniq
      @city_pages.uniq
    end
  end

  def linked_pages_scrape_single_test
    @loc_pages.clear
    page_scrape_for_link("#{base}#{@state_pages[0]}")
    page_scrape_for_link("#{base}#{@city_pages[0]}")
    #binding.pry
  end

  def create_stores
    i = 1
    k = @loc_pages.length
    @loc_pages.each do |loc|
      loc = Nokogiri::HTML5(URI.open("#{base}#{loc}"))
        j = loc.css("li span")
        info = {
          idnum: i,
          address: j[0].text,
          city: j[1].text,
          state: j[2].text,
          zip: j[3].text,
        }
        Store.new(info)
        i += 1
        puts "Store #{i}/#{k}"
      #binding.pry
    end
  end

  def csv_expo(name)
    c = CSV.open("#{name}.csv", "w")
    #csv << headers
    c << ["IDnum", "Address", "City", "State", "ZIP"]
    Store.all.each do |loc|
      c << [loc.idnum, loc.address, loc.city, loc.state, loc.zip]
    end
    c.close()
  end

  def linked_pages_scrape
    i = 0
    l = 0
    h = @state_pages.length
    @state_pages.each do |state|
      page_scrape_for_link("#{base}#{state}")
      i += 1
      j = (i.to_f/h.to_f)*100
      puts "States Progress: #{j.round(2)}%"
    end
    k = @city_pages.length
    @city_pages.each do |city|
      page_scrape_for_link("#{base}#{city}")
      l += 1
      y = (l.to_f/k.to_f)*100
      puts "Cities Progress: #{y.round(2)}%"
    end
    binding.pry
  end

  def clear_all
    @state_pages.clear
    @city_pages.clear
    @loc_pages.clear
  end

  def dedupe_all
    @state_pages.uniq
    @city_pages.uniq
    @loc_pages.uniq
  end

end

#gary = Scraper.new("https://www.havertys.com/furniture/allstores")
#gary = Scraper.new("https://storefound.org/do-it-best-store-hours-locations")
#gary.whole_pull

Scraper.scrape("https://storefound.org/do-it-best-store-hours-locations","https://storefound.org","Do-it-best-test")