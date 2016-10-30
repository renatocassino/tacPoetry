# coding: utf-8
class Preposicao
  def self.data
    %w(a ante até após com contra de desde em entre para per perante por sem sob sobre trás).freeze
  end

  def self.get_word(_)
    self.data[rand(0..self.data.count-1)]
  end
end
