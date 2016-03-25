=begin
  Sequências

  Artigo -> Substantivo, Numeral
  Preposição -> Substantivo, Pronome, Verbo
  Conjunção -> Artigo, Pronome, Advérbio
  Substantivo -> Preposição, Conjunção, Advérbio, Adjetivo
  Pronome -> Conjunção, Verbo
  Verbo -> Artigo, Preposição, Pronome
  Advérbio -> Conjunção, Verbo, Adjetivo
  Adjetivo -> Preposição, Verbo
  Numeral -> Substantivo
=end
module Poetry
  class Markov
    # Type => Collection
    def self.types
      {
          :Art  => {
              class: Artigo,
              nexts: [:Subs] #, :Num]
          },
          :Prep => {
              class: Preposicao,
              nexts: [:Subs, :Conj, :Adv, :Adj]
          },
          :Conj => {
              class: Conjuncao,
              nexts: [:Art, :Pron, :Adv]
          },
          :Subs => {
              class: Substantivo,
              nexts: [:Prep, :Conj, :Adv, :Adj]
          },
          :Pron => {
              class: Pronome,
              nexts: [:Conj, :Verb]
          },
          :Verb => {
              class: Verbo,
              nexts: [:Art, :Prep, :Pron]
          },
          :Adv  => {
              class: Adverbio,
              nexts: [:Conj, :Verb, :Adj]
          },
          :Adj  => {
              class: Adjetivo,
              nexts: [:Prep, :Verb]
          }
          # :Num  => {
          #     class: Numeral,
          #     nexts: [:Subs]
          # },
      }.freeze
    end

    def generate_text_encoded
      types = Markov.types

      text = ""
      current_type = nil
      10.times do
        if current_type.nil?
          current_type = types.keys.sample
        else
          nexts = types[current_type][:nexts]
          current_type = nexts.sample
        end

        text += "#{current_type.to_s}. "
      end

      text
    end

    def decode_text text
      text.gsub(/(?<next>\w+\.(?:[\w]+)*)/) do |word|
        word = word.split '.'
        klass = Markov.types[word[0].to_sym][:class]
        conditions = nil
        conditions = self.get_conditions word[1] unless word[1].nil?

        begin
          klass.get_word conditions
        rescue
          word[0]
        end
      end
    end
  end
end