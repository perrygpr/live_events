class Score < ActiveRecord::Base
  include GuidPrimaryKey
  belongs_to :event, class_name: "Event", foreign_key: "event_id"

  scope :join_cheaters, lambda { select("scores.*, cheaters.id AS cheater_id, cheaters.notes AS cheater_notes").joins("LEFT OUTER JOIN cheaters ON scores.player_id = cheaters.player_id") }
  scope :no_cheaters, lambda { joins("LEFT OUTER JOIN cheaters ON scores.player_id = cheaters.player_id").where("cheaters.player_id IS NULL") }
end
