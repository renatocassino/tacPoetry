class Artigo
  def self.data
    [
        {
            word: 'o',
            type: Word.type[:ARTIGO],
            defined: true,
            masculine: {
                singular: 'o',
                plural: 'os'
            },
            feminine: {
                singular: 'a',
                plural: 'as'
            }
        },
        {
            word: 'um',
            type: Word.type[:ARTIGO],
            defined: false,
            masculine: {
                singular: 'um',
                plural: 'uns'
            },
            feminine: {
                singular: 'uma',
                plural: 'umas'
            }
        },
    ].freeze
  end

  def self.get_word conditions
    data = self.data
    data[rand(0..data.count-1)][:masculine][:singular]
  end

  def self.get_artigo(genre=:masculine, number=:singular)
    data = self.data
    data[rand(0..data.count-1)][genre][number]
  end
end