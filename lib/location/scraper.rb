# frozen_string_literal: true

require_relative "scraper/version"
require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :link, :base

  @@state_pages = []
  @@city_pages = []
  @@loc_pages = []

  def initialize(url)
    @link = url
    @base = "https://storefound.org"
    Scraper.clear_all
  end

  def page_scrape_by_link_haverty
    doc = Nokogiri::HTML5(URI.open(@link))
    att = doc.css(".storeDetails").css("span")
    #binding.pry
  end

  def whole_pull
    page_scrape_for_link(@link)
    linked_pages_scrape
  end

  def page_scrape_for_link(link)
    #finds additional links to follow and sorts into arrays
    doc = Nokogiri::HTML5(URI.open(link))
    doc.css(".main-block a").each do |lk|
      j = lk.attribute("href").text
      case j.split("/").length
      when 3
        @@state_pages << j
      when 4
        @@city_pages << j
      when 5
        @@loc_pages << j
      end
      @@state_pages.uniq
      @@city_pages.uniq
    end
  end

  def linked_pages_scrape
    i = 0
    l = 0
    h = @@state_pages.length
    @@state_pages.each do |state|
      page_scrape_for_link("#{base}#{state}")
      i += 1
      j = (i.to_f/h.to_f)*100
      puts "States Progress: #{j.round(2)}%"
    end
    k = @@city_pages.length
    @@city_pages.each do |city|
      page_scrape_for_link("#{base}#{city}")
      l += 1
      y = (l.to_f/k.to_f)*100
      puts "Cities Progress: #{y.round(2)}%"
    end
    binding.pry
  end

  def self.clear_all
    @@state_pages.clear
    @@city_pages.clear
    @@loc_pages.clear
  end
  def self.states
    puts @@state_pages
  end
  def self.cities
    puts @@city_pages
  end
  def self.locations
    puts @@loc_pages
  end
  def progress
    0.step(100, 5) do |i|
      printf("\rProgress: [%-20s]", "=" * (i/5))
      sleep(0.5)
    end
    puts
  end

end

#gary = Scraper.new("https://www.havertys.com/furniture/allstores")
gary = Scraper.new("https://storefound.org/do-it-best-store-hours-locations")
gary.whole_pull