# coding: utf-8
class String
  def separate_words
    self.dup.to_s.split(/\s/).delete_if(&:blank?)
  end

  def to_slug
    text = self.dup.to_s.downcase

    text = text.gsub(/[áàãâ]/, 'a')
    text = text.gsub(/[éê]/, 'e')
    text = text.gsub(/í/, 'i')
    text = text.gsub(/[óôõ]/, 'o')
    text = text.gsub(/[úû]/, 'u')
    text = text.gsub(/ç/, 'c')

    text = text.gsub(/[^a-z0-9 ]/, "")
    text = text.gsub(' ', '-')
    text = text.gsub(/(\-)+/, '-')
    text = text.gsub(/^\-/, '')
    text.gsub(/\-$/, '')
  end
end
