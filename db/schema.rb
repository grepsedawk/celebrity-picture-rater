# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_03_18_175322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "celebrities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.bigint "celebrity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["celebrity_id"], name: "index_pictures_on_celebrity_id"
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "left_picture_id"
    t.bigint "right_picture_id"
    t.bigint "chosen_picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "celebrity_id"
    t.index ["celebrity_id"], name: "index_votes_on_celebrity_id"
    t.index ["chosen_picture_id"], name: "index_votes_on_chosen_picture_id"
    t.index ["left_picture_id"], name: "index_votes_on_left_picture_id"
    t.index ["right_picture_id"], name: "index_votes_on_right_picture_id"
  end

  add_foreign_key "pictures", "celebrities"
  add_foreign_key "votes", "celebrities"
  add_foreign_key "votes", "pictures", column: "chosen_picture_id"
  add_foreign_key "votes", "pictures", column: "left_picture_id"
  add_foreign_key "votes", "pictures", column: "right_picture_id"

  create_view "picture_points",  sql_definition: <<-SQL
      SELECT point_results.winning_picture_id,
      point_results.celebrity_id,
      count(*) AS points
     FROM ( SELECT
                  CASE
                      WHEN (picture_wins.least_picture_wins > picture_wins.greatest_picture_wins) THEN picture_wins.least_picture_id
                      WHEN (picture_wins.greatest_picture_wins > picture_wins.least_picture_wins) THEN picture_wins.greatest_picture_id
                      ELSE NULL::bigint
                  END AS winning_picture_id,
              picture_wins.celebrity_id
             FROM ( SELECT LEAST(votes.left_picture_id, votes.right_picture_id) AS least_picture_id,
                      GREATEST(votes.left_picture_id, votes.right_picture_id) AS greatest_picture_id,
                      COALESCE(sum(
                          CASE votes.chosen_picture_id
                              WHEN LEAST(votes.left_picture_id, votes.right_picture_id) THEN 1
                              ELSE NULL::integer
                          END), (0)::bigint) AS least_picture_wins,
                      COALESCE(sum(
                          CASE votes.chosen_picture_id
                              WHEN GREATEST(votes.left_picture_id, votes.right_picture_id) THEN 1
                              ELSE NULL::integer
                          END), (0)::bigint) AS greatest_picture_wins,
                      votes.celebrity_id
                     FROM votes
                    GROUP BY LEAST(votes.left_picture_id, votes.right_picture_id), GREATEST(votes.left_picture_id, votes.right_picture_id), votes.celebrity_id
                    ORDER BY (count(*)) DESC) picture_wins) point_results
    WHERE (point_results.winning_picture_id IS NOT NULL)
    GROUP BY point_results.winning_picture_id, point_results.celebrity_id
    ORDER BY (count(*)) DESC;
  SQL

end
