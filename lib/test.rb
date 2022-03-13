#run small scrapes to test the program on the actual site
#I should really learn more about wrtiting a test suite lol

require_relative "scraper_module"
require_relative 'store'
require_relative 'export'


def linked_pages_scrape_single_test
    @loc_pages.clear
    page_scrape_for_link("#{@base}#{@state_pages[0]}")
    page_scrape_for_link("#{@base}#{@city_pages[0]}")
end