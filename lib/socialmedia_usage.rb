require "socialmedia_usage/version"
require 'unirest'

module Nyc
  class Social
    attr_reader :agency, :url, :platform

    def initialize(agency)
      @agency = agency['agency']
      @platform = agency['platform']
      @url = agency['url']
    end

    def self.all
      agencies_array = Unirest.get('https://data.cityofnewyork.us/resource/pbc3-75xt.json').body
      create_agencies(agencies_array)
    end

    def self.where(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      agencies_array = Unirest.get("https://data.cityofnewyork.us/resource/pbc3-75xt.json?#{key}=#{value}").body
      create_agencies(agencies_array)
    end

    def self.find_by(search_term)
      key = search_term.keys.first.to_s
      value = search_term.values.first
      agency = Unirest.get("https://data.cityofnewyork.us/resource/pbc3-75xt.json?#{key}=#{value}").body.first
      Social.new(agency)
    end

    def self.create_agencies(agencies_array)
      agencies_array.map {|agency| Social.new(agency)}
    end

    private_class_method :create_agencies
  end
end
