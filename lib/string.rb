class String
  def separate_words
    self.dup.to_s.split(/\s/).delete_if(&:blank?)
  end
end