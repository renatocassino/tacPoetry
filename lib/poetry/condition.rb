module Poetry
  class Condition
    def initialize
      @tempo = nil
      @genero = nil
      @grau = nil

      self.reset
    end

    def reset
      @genero = [:mas, :fem][SecureRandom.random_number(2)]
      @grau = [:sin, :plu][SecureRandom.random_number(2)]
      nil
    end

    def genero
      @genero
    end

    def grau
      @grau
    end

    def clear
      @genero = nil
      @grau = nil
      @tempo = nil
    end

    def attributes
      {
        tempo: @tempo,
        genero: @genero,
        grau: @grau
      }
    end

    # @param <string> conditions
    def set_conditions conditions
      self.clear
      return if conditions.nil?
      conditions.split('&').map { |cond|
        begin
          cond = cond.split ':'
          next if cond[1].nil?

          instance = "@#{cond[0]} = :#{cond[1]}"
          eval instance
        rescue
        end
      }

      nil
    end

    def get_conditions keys=nil
      condition = {
        tempo: @tempo,
        grau: @grau,
        genero: @genero
      }

      condition.map { |key, cond| "#{key}:#{cond}" }.join '&'
    end
  end
end
