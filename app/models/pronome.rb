class Pronome
  def self.data
    [
        "eu",
        "tu",
        "ele",
        "ela",
        "nós",
        "vós",
        "eles",
        "elas",
        "você",
        "vocês"
    ].freeze
  end

  def self.get_word conditions
    self.data.sample
  end
end