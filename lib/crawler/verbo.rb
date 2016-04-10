# coding: utf-8
module Crawler
  class Verbo
    def self.run
      verbs = self.get_all_verbs
      self.insert_in_db verbs
    end

    def self.de_para_tempo
      {
        "Presente do Indicativo" => :pre,
        "Pretérito Imperfeito do Indicativo" => :prtImp,
        "Pretérito Perfeito do Indicativo" => :prtPft,
        "Mais-que-perfeito do Indicativo" => :prtMqp,
        "Futuro do Pretérito do Indicativo" => :futPrt,
        "Futuro do Presente do Indicativo" => :futPre
      }.freeze
    end

    def self.de_para_pronome
      {
        "eu" => [:sin, :primeira],
        "tu" => [:sin, :segunda],
        "ele" => [:sin, :terceira],
        "nós" => [:plu, :primeira],
        "vós" => [:plu, :segunda],
        "eles" => [:plu, :terceira]
      }.freeze
    end

    def self.get_all_verbs
      Word.where(type: Regexp.new('verbo_(irregular|regular)')).all
    end

    def self.insert_in_db verbs
      verbs.each do |verb|
        if ::Verbo.where(word: verb.word).count == 0
          verbo = ::Verbo.new
          verbo.word = verb.word
          verbo.stemmed = verb.word.brstemmer

          if verb.type == 'verbo_regular'
            verbo.type = 'regular'
            verbo.save
          else
            verbo.type = 'irregular'
            page = self.parse_page verb
            verbos_dom = page.css('.verb-wrapper > ul > li')

            verbos_dom.each do |node|
              tempo = node.css('.tempo').text
              conjugacao = node.text.scan(/(?<pronome>(eu|tu|ele|nós|vós|eles)) (?<verbo>[\wáàãâéêíóôõú-]+)/)

              tempo = self.de_para_tempo[tempo]
              next if tempo.nil?

              conjugacao.each do |conj|
                pronome = self.de_para_pronome[conj[0]]
                verbo[tempo] = {} if verbo[tempo].nil?
                verbo[tempo][pronome[0]] = {} if verbo[tempo][pronome[0]].nil?
                verbo[tempo][pronome[0]][pronome[1]] = conj[1]
              end
            end

            verbo.save

          end
        end
      end
    end

    def self.parse_page verb
      begin
        url = "http://www.dicio.com.br/#{verb.word.to_slug}/"
        content = Net::HTTP.get(URI.parse(url))
        Nokogiri::HTML content
      rescue
      end
    end
  end
end
