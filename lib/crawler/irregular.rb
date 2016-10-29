# Sorry for this code!
module Crawler
  class Irregular
    def self.run
      Word.where(type: "verbo_irregular").all.each do |word|
        word = word.word
        conjugar(word) unless exists?(word)
      end
    end

    def self.exists?(word)
      ::Verbo.where(stemmed: word.brstemmer, type: 'irregular').count > 0
    end

    def self.conjugar(word)
      verbo = ::Verbo.new
      verbo.word = word
      verbo.type = 'irregular'
      change_verb verbo
      verbo.save
    end

    def self.change_verb(verbo)
      content = parse verbo.word
      idx = 0
      verbo[:pre] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }

      idx = 5

      verbo[:prtPft] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }

      idx = 2

      verbo[:prtImp] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }

      idx = 4

      verbo[:prtMqp] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }

      idx = 9

      verbo[:futPrt] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }


      idx = 7

      verbo[:futPre] = {
        sin: {
          primeira: content.css('.tempscorps')[idx].css('b')[0].text,
          segunda: content.css('.tempscorps')[idx].css('b')[1].text,
          terceira: content.css('.tempscorps')[idx].css('b')[2].text
        },
        plu: {
          primeira: content.css('.tempscorps')[idx].css('b')[3].text,
          segunda: content.css('.tempscorps')[idx].css('b')[4].text,
          terceira: content.css('.tempscorps')[idx].css('b')[5].text
        }
      }
    end

    def self.parse(word)
      url = "http://www.conjugacao-de-verbos.com/verbo/#{word}.php"
      begin
        content = Net::HTTP.get(URI.parse(url))
        Nokogiri::HTML content
      rescue
      end
    end
  end
end
