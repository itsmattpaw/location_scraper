# frozen_string_literal: true

require_relative "scraper/version"

module Location
  module Scraper
    class Error < StandardError; end
    # Your code goes here...
  end
end

require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :link, :file

  @@pages = []

  def initialize(url)
    @link = url
  end

  def page_scrape_by_link_haverty
    doc = Nokogiri::HTML5(URI.open(@link))
    att = doc.css(".storeDetails").css("span")
    #binding.pry
  end

  def page_scrape_by_link_do_it_best_state
    doc = Nokogiri::HTML5(URI.open(@link))
    doc.css(".main-block a").each do |lk|
      j = lk.attribute("href").text
      if j.split("/").length == 3
        @@pages << j
      end
    end
    #binding.pry
  end

  def page_scrape_by_link_do_it_best_city
    doc = Nokogiri::HTML5(URI.open(@link))
    doc.css(".main-block a").each do |lk|
      j = lk.attribute("href").text
      if j.split("/").length == 4
        #@@pages << j
      end
    end
    #binding.pry
  end

  def do_it_best_locations(url)
    doc = Nokogiri::HTML5(URI.open("https://storefound.org#{url}"))

  end

  def self.pages
    puts @@pages
  end

end

#gary = Scraper.new("https://www.havertys.com/furniture/allstores")
gary = Scraper.new("https://storefound.org/do-it-best-store-hours-locations")
gary.page_scrape_by_link_do_it_best_state
Scraper.pages