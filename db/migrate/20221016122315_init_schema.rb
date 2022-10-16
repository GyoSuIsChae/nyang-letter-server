# frozen_string_literal: true

class InitSchema < ActiveRecord::Migration[7.0]
  def up
    create_table :users, comment: "사용자" do |t|
      t.string :uid, limit: 36, index: true
      t.string :nickname, limit: 100, comment: "닉네임"
      t.string :login_type, limit: 2, comment: "로그인 타입 10: kakao 20: google 30: naver"
      t.string :email, limit: 100, comment: "이메일"
      t.string :is_complete_tutorial, limit: 1, default: "N", comment: "튜토리얼 완료 여부 Y/N"
      t.string :status, limit: 2, default: "10", comment: "상태 10: active 20: inactive 99: leave"
      t.timestamps
      t.datetime :deleted_at
    end

    create_table :cafes, comment: "카페" do |t|
      t.string :uid, limit: 36, index: true
      t.belongs_to :user
      t.string :name, limit: 100, comment: "카페 이름"
      t.string :theme, limit: 3, comment: "10: new_year 20: birthday 30: christmas"
      t.bigint :unread_letter_count, default: 0, comment: "읽지 않은 편지 개수"
      t.datetime :open_at, comment: "카페 오픈 일시"
      t.string :status, limit: 2, default: "10", comment: "상태 10: before_opening 20: opening 99: deleted"
      t.timestamps
      t.datetime :deleted_at
    end

    create_table :short_urls, comment: "단축 URL" do |t|
      t.string :uid, limit: 8, index: true
      t.belongs_to :user, comment: "단축 URL 생성자"
      t.references :urlable, polymorphic: true, comment: "단축 URL 대상"
      t.datetime :read_at, comment: "단축 URL 읽은 일시"
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def down
    drop_table :users
    drop_table :cafes
    drop_table :short_urls
  end
end
