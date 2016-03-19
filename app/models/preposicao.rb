class Preposicao
  def self.data
    return %w(a ante ate apos com contra de desde em entre para per perante por sem sob sobre trás).freeze
  end

  def self.get_preposicao
    self.data[rand(0..self.data.count-1)]
  end
end