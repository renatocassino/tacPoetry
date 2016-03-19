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
        current_url = @urls[readed]
        readed+=1

        self.get_info current_url

        break if readed >= @urls.count
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
      content = Net::HTTP.get(URI.parse("http://www.dicio.com.br#{current_url}"))
      Nokogiri::HTML content
    end

    def go
      readed = 0
      loop do
        url = @urls_words[readed]
        puts "Crawling the word #{url}.....".colorize(:green)
        readed+=1

        page = self.parse_page url

        begin
          page.css('.adicional.sinonimos > a').each { |new_page| @urls_words << new_page.attributes['href'].value }
          @urls_words.uniq!

          word_title = page.css('#content .card h1').first.content
          word_stemmed = word_title.brstemmer
          if Word.where(stemmed: word_stemmed).count == 0
            type = self.get_type page
            continue unless type

            word = Word.new
            word.word = word_title
            word.type = type
            word.stemmed = word_stemmed
            word.save

            puts " - Word #{word.word} appended in database".colorize(:green)
          end
        rescue
        end

        break if readed >= @urls_words.count
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
        Word.type[:VERBO]
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