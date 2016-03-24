class VerboRegular
  include Mongoid::Document

  store_in collection: "verbos"

  field :word, type: String # Encontrada pelo dicionário
  field :stemmed, type: String

  def conjugado
    # Magia here
    word = self.fields[:stemmed]
    {
      :prtPft => {
          :sin => {
              primeira: "#{word}ei",
              segunda: "#{word}aste",
              terceira: "#{word}ou"
          },
          :plu => {
              primeira: "#{word}amos",
              segunda: "#{word}astes",
              terceira: "#{word}aram"
          }
      },
      :prtImp => {
          :sin => {
              primeira: "#{word}ava",
              segunda: "#{word}avas",
              terceira: "#{word}ava"
          },
          :plu => {
              primeira: "#{word}ávamos",
              segunda: "#{word}áveis",
              terceira: "#{word}avam"
          }
      },
      :prtMqp => {
          :sin => {
              primeira: "#{word}ara",
              segunda: "#{word}aras",
              terceira: "#{word}ara"
          },
          :plu => {
              primeira: "#{word}áramos",
              segunda: "#{word}áreis",
              terceira: "#{word}aram"
          }
      },
      :pre => {
          :sin => {
              primeira: "#{word}o",
              segunda: "#{word}as",
              terceira: "#{word}a"
          },
          :plu => {
              primeira: "#{word}amos",
              segunda: "#{word}ais",
              terceira: "#{word}am"
          }
      },
      :futPrt => {
          :sin => {
              primeira: "#{word}aria",
              segunda: "#{word}arias",
              terceira: "#{word}aria"
          },
          :plu => {
              primeira: "#{word}aríamos",
              segunda: "#{word}aríeis",
              terceira: "#{word}ariam"
          }
      },
      :futPre => {
          :sin => {
              primeira: "#{word}arei",
              segunda: "#{word}arás",
              terceira: "#{word}ará"
          },
          :plu => {
              primeira: "#{word}aremos",
              segunda: "#{word}areis",
              terceira: "#{word}arão"
          }
      }
    }.freeze
  end
end