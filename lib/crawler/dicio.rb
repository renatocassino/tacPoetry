# coding: iso-8859-1
require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'brstemmer'

module Crawler
  class Dicio

    def self.run
      crawler = Dicio.new true
      crawler.init

      puts 'Getting pages urls...'.colorize(:green)
      crawler.get_pagination_links

      crawler.go
    end

    def initialize verbose=false
      @verbose = verbose
    end

    def init
      @urls = ['/ultimas_atualizacoes/']
      @urls_words = []
    end

    def get_pagination_links
      readed = 0
      loop do
        begin
          current_url = @urls[readed]
          readed+=1

          self.get_info current_url

          break if readed >= @urls.count
        rescue
        end
      end
    end

    def get_info current_url
      page = self.parse_page current_url

      page.css('.paginacao > a').each { |new_page| @urls << new_page.attributes['href'].value }
      page.css('ul.list > li > a').each { |new_page| @urls_words << new_page.attributes['href'].value }
      @urls.uniq!
      @urls_words.uniq!
    end

    def parse_page current_url
      begin
        content = Net::HTTP.get(URI.parse("http://www.dicio.com.br#{current_url}"))
        Nokogiri::HTML content
      rescue
      end
    end

    def go
      readed = 0
      loop do
        url = @urls_words[readed]
        puts "Crawling the word #{url}.....".colorize(:green)
        readed+=1

        page = self.parse_page url
        self.craw page

        break if readed >= @urls_words.count
      end
    end

    def craw page
      begin
        @urls_words = [] if @urls_words.nil?

        page.css('.adicional.sinonimos > a').each { |new_page| @urls_words <<

            new_page.attributes['href'].value }
        @urls_words.uniq!

        word_title = page.css('#content .card h1').first.content
        if word_title.match(/ /).nil?
          
          word_stemmed = word_title.brstemmer

          type = self.get_type page
          return unless type

          if Word.where(stemmed: word_stemmed, type: type).count == 0

            word = Word.new
            word.word = word_title
            word.type = type
            word.stemmed = word_stemmed
            word.save

            puts " - Word #{word.word} appended in database".colorize(:green)
          end
        end
      rescue
      end
    end

    def get_type page
      classe_gramatical = page.css('.card p.adicional:not(.sinonimos) > b:first-child').first.content.downcase
      if (classe_gramatical =~ /sigla/i) == 0
        false
      elsif classe_gramatical =~ /preposição/i
        Word.type[:PREPOSICAO]
      elsif classe_gramatical =~ /substantivo/i
        Word.type[:SUBSTANTIVO]
      elsif classe_gramatical =~ /verbo/i
        type_content = page.css('#conjugacao > p').first.content
        if type_content.match(/Tipo do Verbo+\: (?<type>\w+)/i)[:type] == 'regular'
          Word.type[:VERBO_REGULAR]
        else
          Word.type[:VERBO_IRREGULAR]
        end
      elsif classe_gramatical =~ /adjetivo/i
        Word.type[:ADJETIVO]
      elsif classe_gramatical =~ /advérbio/i
        Word.type[:ADVERBIO]
      elsif classe_gramatical =~ /apositivo/i
        Word.type[:APOSITIVO]
      end
    end
  end
end
