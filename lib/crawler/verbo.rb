module Crawler
  class Verbo
    def self.run
      verbs = self.get_all_verbs
      self.insert_in_db verbs
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

            self.parse_page verb
            .tempo-conjugacao

            verbo.pre[:sin]

            :prtPft
            :prtImp
            :prtMqp
            :pre
            :futPrt
            :futPre

            {
                :sin => {
                    primeira: nil,
                    segunda: nil,
                    terceira: nil
                },
                :plu => {
                    primeira: nil,
                    segunda: nil,
                    terceira: nil
                }
            }

          end
        end
      end
    end

    def self.parse_page verb
      def parse_page current_url
        begin
          content = Net::HTTP.get(URI.parse("http://www.dicio.com.br#{current_url}"))
          Nokogiri::HTML content
        rescue
        end
      end
    end
  end
end