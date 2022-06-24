class Game < ApplicationRecord
    # Todas las cartas de UNO
    # R = rojo
    # G = verde
    # B = azul
    # Y = amarillo
    # skip = saltear
    # _ = reversa
    # D2 = robar 2
    # W = elegir color
    # D4W = elegir color y robar 4
    PACK_OF_CARDS = [
        '0R', '1R', '1R', '2R', '2R', '3R', '3R', '4R', '4R', '5R', '5R', '6R', '6R', '7R', '7R', '8R', '8R', '9R', '9R', 'skipR', 'skipR', '_R', '_R', 'D2R', 'D2R',
        '0G', '1G', '1G', '2G', '2G', '3G', '3G', '4G', '4G', '5G', '5G', '6G', '6G', '7G', '7G', '8G', '8G', '9G', '9G', 'skipG', 'skipG', '_G', '_G', 'D2G', 'D2G',
        '0B', '1B', '1B', '2B', '2B', '3B', '3B', '4B', '4B', '5B', '5B', '6B', '6B', '7B', '7B', '8B', '8B', '9B', '9B', 'skipB', 'skipB', '_B', '_B', 'D2B', 'D2B',
        '0Y', '1Y', '1Y', '2Y', '2Y', '3Y', '3Y', '4Y', '4Y', '5Y', '5Y', '6Y', '6Y', '7Y', '7Y', '8Y', '8Y', '9Y', '9Y', 'skipY', 'skipY', '_Y', '_Y', 'D2Y', 'D2Y',
        'W', 'W', 'W', 'W', 'D4W', 'D4W', 'D4W', 'D4W'
    ]

    # Quien crea una partida es el jugador 1, quien se une es el 2
    belongs_to :player_1, class_name: 'User'
    belongs_to :player_2, class_name: 'User', required: false

    validates :player_1, presence: true
    validates :player_2, presence: true, allow_nil: true

    before_create :set_initial_decks

    # Cada montículo de cartas (las de la mano de cada jugador, las que están en juego y las que se roban del mazo) se representan mediante arreglos
    def set_initial_decks
        self.player_1_hand = []
        self.player_2_hand = []
        self.played_cards_pile = []
        self.draw_card_pile = PACK_OF_CARDS
    end
end