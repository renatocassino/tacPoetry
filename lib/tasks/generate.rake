namespace :generate do
  desc "TODO"
  task substantivos: :environment do
    Word.where(type: 'substantivo').order(type: :desc).all.each do |word|
      puts word.word
    end
  end

end
