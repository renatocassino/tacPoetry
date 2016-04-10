# coding: iso-8859-1
namespace :generate do
  desc "Gerando substantivos a partir da collection words"
  task substantivos: :environment do
    Word.where(type: 'substantivo').order(type: :desc).all.each do |word|
      puts "Reading #{word.word.colorize(:green)}..."
      puts "Getting info about #{word.word}".colorize(:green)

      substantivo = Substantivo.where(word: word.word).first
      unless substantivo
        generate_substantivo word.word
      else
        substantivo.delete # REFACTOR THIS
        generate_substantivo word.word
      end
    end
  end

  def generate_substantivo word
    url = "http://www.dicio.com.br/#{word.slugify}/"
    puts "Getting url #{url.colorize :yellow}"
    content = Net::HTTP.get(URI.parse(url))
    page = Nokogiri::HTML content

    begin
      type = page.css('.card p.adicional:not(.sinonimos) > b:first-child').first.content.downcase
      title = word_title = page.css('#content .card h1').first.content

      substantivo = Substantivo.new
      substantivo.type = Word.type[:SUBSTANTIVO]
      substantivo.stemmed = word.brstemmer

      content = page.css('.card p.adicional:not(.sinonimos)')
      content.css('br').each { |node| node.replace "\n" }

      return if (content.first.content =~ /substantivo/).nil?

      if type =~ /feminino/i
        substantivo.fem_sin = title
        begin
          plu = content.first.content.match(/Plura(?:l|is): (?<word>.+)/)
          word = plu[:word]
          unless (word =~ /,/).nil?
            word = word.split(',')[0]
          end
          substantivo.fem_plu = word
        rescue
          substantivo.fem_plu = title + "s"
        end

        substantivo.has_fem = true
        substantivo.has_mas = false
      else
        feminine_singular = page.css('.card p.adicional:not(.sinonimos) > b:nth-child(7)')
        if feminine_singular.count > 0
          
          feminine_singular = feminine_singular.first.content.downcase
          subs = Substantivo.where(fem_sin: feminine_singular, has_fem: true)

          if subs.count > 0
            substantivo = subs.first
          else
            substantivo.has_fem = false
            substantivo.has_mas = true
          end
        else
          substantivo.has_fem = false
          substantivo.has_mas = true
        end

        substantivo.mas_sin = title
        begin
          plu = content.first.content.match(/Plura(?:l|is): (?<word>.+)/)
          word = plu[:word]
          unless (word =~ /,/).nil?
            word = word.split(',')[0]
          end
          substantivo.mas_plu = word
        rescue
          substantivo.mas_plu = title + "s"
        end
      end

      puts "Saving word #{title}".colorize :green
      substantivo.save
    rescue
    end
  end

end
