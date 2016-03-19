namespace :generate do
  desc "TODO"
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
      substantivo.word = title
      substantivo.type = Word.type[:SUBSTANTIVO]
      substantivo.stemmed = word.brstemmer

      if type =~ /feminino/i
        plural = page.css('.card p.adicional:not(.sinonimos) > b:nth-child(5)').first.content.downcase
        substantivo.feminine_singular = title
        substantivo.feminine_plural = plural
        substantivo.word_plural = plural
      else
        plural = page.css('.card p.adicional:not(.sinonimos) > b:nth-child(5)').first.content.downcase
        feminine_singular = page.css('.card p.adicional:not(.sinonimos) > b:nth-child(7)').first.content.downcase
        substantivo.word_plural = plural
        substantivo.feminine_singular = feminine_singular
        substantivo.feminine_plural = feminine_singular + 's'
      end

      puts "Saving word #{substantivo.word}".colorize :green
      substantivo.save
    rescue
    end
  end

end
