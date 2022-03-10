require_relative "scraper/version"
require 'nokogiri'
require 'open-uri'
require 'pry'

#takes scraped data and creates store class instance
#saves all store class instances to be exported
class Store

def