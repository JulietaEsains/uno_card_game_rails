class GamesController < ApplicationController
  private

  # Getter
  attr_reader :current_user

  # Retorna las partidas relacionadas al usuario actual, ya sea como jugador 1 o jugador 2
  def base_query
    Game.where('player_1_id = :user or player_2_id = :user', user: current_user.id)
  end

  # Guarda el estado de la partida
  def save(game, status = 200)
    if game.save
      render status: status, json: {game: game}
    else
      render status: 400, json: {errors: game.errors.details}
    end
  end

  # Repartición inicial de cartas
  def distribute_cards(game)
    # Mezclar mazo
    game.draw_card_pile.shuffle!

    # Repartir 7 cartas a cada jugador
    7.times do
      card_1 = game.draw_card_pile.pop
      game.player_1_hand = game.player_1_hand.push(card_1)

      card_2 = game.draw_card_pile.pop
      game.player_2_hand = game.player_2_hand.push(card_2)
    end

    # Colocar carta inicial
    initial_card = game.draw_card_pile.pop
    game.played_cards_pile = game.played_cards_pile.push(initial_card)
  end

  # Robar una carta
  def draw_card(game)
    card = game.draw_card_pile.pop
    
    if (game.player_1 == current_user)
      game.player_1_hand = game.player_1_hand.push(card)
    elsif (game.player_2 == current_user)
      game.player_2_hand = game.player_2_hand.push(card)
    end
  end

  # Poner una carta en juego
  def play_card(game, index)

    if (game.player_1 == current_user)
      card = game.player_1_hand.delete_at(index)
    elsif (game.player_2 == current_user)
      card = game.player_2_hand.delete_at(index)
    end

    game.played_cards_pile = game.played_cards_pile.push(card)
  end

  # Cambiar turno
  def toggle_turn(game)
    if (game.turn == '1')
      game.turn = '2'
    else
      game.turn = '1'
    end
  end

  # Sumar un punto de victoria a uno de los jugadores
  def increment_wins_counter(game, player)
    if (player == '1')
      game.player_1_wins += 1
    elsif (player == '2')
      game.player_2_wins += 1
    end
  end

  # Quitar un punto de victoria a uno de los jugadores 
  def decrease_wins_counter(game, player)
    if (player == '1')
      game.player_1_wins -= 1
    elsif (player == '2')
      game.player_2_wins -= 1
    end
  end

  # Reiniciar los mazos para jugar nuevamente
  def restart(game)
    game.player_1_hand.each {|card| game.draw_card_pile = game.draw_card_pile.push(card)}
    game.player_2_hand.each {|card| game.draw_card_pile = game.draw_card_pile.push(card)}
    game.played_cards_pile.each {|card| game.draw_card_pile = game.draw_card_pile.push(card)}

    game.player_1_hand = []
    game.player_2_hand = []
    game.played_cards_pile = []
  end
      
  public

  # GET /games
  # Partidas del jugador actual
  def index
    render json: {games: base_query}
  end

  # GET /games/:id
  def show
    render json: {game: base_query.find(params[:id])}
  end

  # POST /games
  def create
    game = Game.new(player_1: current_user)
    save game, 201 
  end

  # PATCH /games/:id
  # La partida se actualiza de varias maneras posibles
  def update
    if (updates = params[:game]) && !updates.empty?

      game = base_query.find(params[:id])

      if (update_type = updates[:update_type])
        
        case update_type
        when 'distribute'
          distribute_cards(game)
        when 'draw'
          draw_card(game)
        when 'play'
          play_card(game, updates[:card_index])
        when 'turn'
          toggle_turn(game)
        when 'add win'
          increment_wins_counter(game, updates[:player])
        when 'remove win'
          decrease_wins_counter(game, updates[:player])
        when 'restart'
          restart(game)
        end

      end

      save game

    else # El jugador 2 se une a la partida
      game = Game.find(params[:id])

      if game.player_2 || game.player_1 == current_user
        render status: 400, json: {errors: game.errors.details}
      else
        game.player_2 = current_user
        save game
      end  
    end  
  end

  # DELETE /games/:id
  def destroy
    game = base_query.find(params[:id])
    if game.destroy
      render status: 200, json: {message: "Partida borrada correctamente."}
    else 
      render status: 400, json: {errors: game.errors.details}
    end
  end
end