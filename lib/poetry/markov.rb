# coding: utf-8
=begin
  Sequências

  Artigo -> Substantivo, Numeral
  Preposição -> Substantivo, Pronome, Verbo
  Conjunção -> Artigo, Pronome, Advérbio
  Substantivo -> Preposiçãoo, Conjunção, Advérbio, Adjetivo
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
              class: ::Artigo,
              nexts: [:Subs] #, :Num]
          },
          :Prep => {
              class: ::Preposicao,
              nexts: [:Subs, :Conj, :Adv, :Adj]
          },
          :Conj => {
              class: ::Conjuncao,
              nexts: [:Art, :Pron, :Adv]
          },
          :Subs => {
              class: ::Substantivo,
              nexts: [:Prep, :Conj, :Adv, :Adj]
          },
          :Pron => {
              class: ::Pronome,
              nexts: [:Conj, :Verb]
          },
          :Verb => {
              class: ::Verbo,
              nexts: [:Art, :Prep, :Pron]
          },
          :Adv  => {
              class: ::Adverbio,
              nexts: [:Conj, :Verb, :Adj]
          },
          :Adj  => {
              class: ::Adjetivo,
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
      condition = Condition.new

      text = []
      current_type = nil
      30.times do
        if current_type.nil?
          current_type = types.keys[SecureRandom.random_number(types.keys.size)]
        end

        text << "#{current_type.to_s}.#{condition.get_conditions}"

        nexts = types[current_type][:nexts]
        current_type = nexts[SecureRandom.random_number(nexts.size)]
      end

      text.join ' '
    end

    def human_text text
      text.gsub(/(?<word>[A-Z]\w+\.(?:[\w:&]*))/) do |word|
        word = word.split '.'
        word[0]
      end
    end

    def decode_text text
      condition = Condition.new
      text.gsub(/(?<word>[A-Z]\w+\.(?:[\w:&]*))/) do |word|
        word = word.split '.'
        klass = Markov.types[word[0].to_sym][:class]
        condition.set_conditions word[1]

        begin
          klass.get_word condition
        rescue
          Rails.logger.error ">>>>>>>>>>>>>>> #{word[0]} #{word[1]}"
          word[0]
        end
      end
    end
  end
end
