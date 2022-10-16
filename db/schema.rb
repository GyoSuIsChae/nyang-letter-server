# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_16_122315) do
  create_table "cafes", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "카페", force: :cascade do |t|
    t.string "uid", limit: 36
    t.bigint "user_id"
    t.string "name", limit: 100, comment: "카페 이름"
    t.string "theme", limit: 3, comment: "10: new_year 20: birthday 30: christmas"
    t.bigint "unread_letter_count", default: 0, comment: "읽지 않은 편지 개수"
    t.datetime "open_at", comment: "카페 오픈 일시"
    t.string "status", limit: 2, default: "10", comment: "상태 10: before_opening 20: opening 99: deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["uid"], name: "index_cafes_on_uid"
    t.index ["user_id"], name: "index_cafes_on_user_id"
  end

  create_table "short_urls", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "단축 URL", force: :cascade do |t|
    t.string "uid", limit: 8
    t.bigint "user_id", comment: "단축 URL 생성자"
    t.string "urlable_type"
    t.bigint "urlable_id", comment: "단축 URL 대상"
    t.datetime "read_at", comment: "단축 URL 읽은 일시"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["uid"], name: "index_short_urls_on_uid"
    t.index ["urlable_type", "urlable_id"], name: "index_short_urls_on_urlable"
    t.index ["user_id"], name: "index_short_urls_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", comment: "사용자", force: :cascade do |t|
    t.string "uid", limit: 36
    t.string "nickname", limit: 100, comment: "닉네임"
    t.string "login_type", limit: 2, comment: "로그인 타입 10: kakao 20: google 30: naver"
    t.string "email", limit: 100, comment: "이메일"
    t.string "is_complete_tutorial", limit: 1, default: "N", comment: "튜토리얼 완료 여부 Y/N"
    t.string "status", limit: 2, default: "10", comment: "상태 10: active 20: inactive 99: leave"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["uid"], name: "index_users_on_uid"
  end

end
