class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :player_1, null: false
      t.references :player_2
      t.integer :player_1_wins, default: 0
      t.integer :player_2_wins, default: 0
      t.string :player_1_hand, array: true
      t.string :player_2_hand, array: true
      t.string :played_cards_pile, array: true
      t.string :draw_card_pile, array: true
      t.string :turn, default: '1'

      t.timestamps
    end
  end
end
