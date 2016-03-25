class Preposicao
  def self.data
    %w(a ante ate apos com contra de desde em entre para per perante por sem sob sobre trás).freeze
  end

  def self.get_word conditions
    self.data[rand(0..self.data.count-1)]
  end
end