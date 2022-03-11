# frozen_string_literal: true

require_relative "store"
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

class Scraper
  attr_accessor :link, :base, :state_pages, :city_pages, :loc_pages, :name

  def initialize(url,base,name)
    @link = url
    @base = base
    @name = name
    @state_pages = []
    @city_pages = []
    @loc_pages = []
  end

  def scrape
    page_scrape_for_link(@link)
    #linked_pages_scrape
    linked_pages_scrape_single_test
    create_stores
    csv_expo
  end

  def page_scrape_for_link(page)
    #finds additional links to follow and sorts into arrays
    doc = Nokogiri::HTML5(URI.open(page))
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
    end
    dedupe_all
  end

  def linked_pages_scrape_single_test
    @loc_pages.clear
    page_scrape_for_link("#{@base}#{@state_pages[0]}")
    page_scrape_for_link("#{@base}#{@city_pages[0]}")
  end

  def linked_pages_scrape(array)
    i = 1
    array.each do |page|
      page_scrape_for_link("#{@base}#{page}")
      progress_perc(i, array.length)
      i += 1
    end
  end

  def create_stores
    i = 1
    @loc_pages.each do |loc|
      loc = Nokogiri::HTML5(URI.open("#{@base}#{loc}"))
        j = loc.css("li span")
        info = {
          idnum: i,
          address: j[0].text,
          city: j[1].text,
          state: j[2].text,
          zip: j[3].text
        }
        Store.new(info)
        puts "Store #{i}/#{@loc_pages.length}"
        i += 1
    end
  end

  def csv_expo
    c = CSV.open("#{@name}.csv", "w")
    c << ["IDnum", "Address", "City", "State", "ZIP"]
    Store.all.each do |loc|
      c << [loc.idnum, loc.address, loc.city, loc.state, loc.zip]
    end
    c.close()
  end

  def progress_perc(place, total)
    perc = (place.to_f/total.to_f)*100
    puts "Progress: #{perc}%"
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

gary = Scraper.new("https://storefound.org/do-it-best-store-hours-locations","https://storefound.org","Do-it-best-test")
gary.scrape