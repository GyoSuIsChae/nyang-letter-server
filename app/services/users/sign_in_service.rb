# frozen_string_literal: true

require "cgi"

class Users::SignInService < ServiceBase
  string :login_type, :access_code

  validates :login_type, inclusion: { in: %w[KAKAO GOOGLE NAVER] }

  def execute
    # login_type에 따라서 다른 로직을 수행한다.
    case login_type
    when "KAKAO"
      @client = OAuth2::Client.new(ENV["KAKAO_CLIENT_ID"],
                                   ENV["KAKAO_CLIENT_SECRET"],
                                   authorize_url: "/oauth/authorize",
                                   site: ENV["KAKAO_OAUTH_IDP_URL"],
                                   token_url: "/oauth/token",
                                   redirect_uri: ENV["KAKAO_OAUTH_REDIRECT_URL"])

      @token = @client.auth_code.get_token(access_code, redirect_uri: ENV["KAKAO_OAUTH_REDIRECT_URL"])

      kakao_token = "Bearer " + @token.token

      faraday_obj = Faraday.get(ENV["KAKAO_USER_INFO_API_URL"], {}, { "Authorization" => kakao_token, "Content-Type" => "application/x-www-form-urlencoded;charset=utf-8" })
      @user_info = JSON.parse(faraday_obj.body)

      @user = User.by_login_type(login_type.downcase).by_social_id(@user_info["id"]).last

      if @user.nil?
        @user = User.create!(login_type: login_type.downcase, nickname: generate_nickname, email: @user_info["kakao_account"]["email"], is_complete_tutorial: "N", status: "10", social_id: @user_info["id"])
      end

      { access_token: access_token, refresh_token: refresh_token }
    when "GOOGLE"
      # 구글 로그인 로직
      # https://accounts.google.com/o/oauth2/v2/auth
      @client = OAuth2::Client.new(ENV["GOOGLE_CLIENT_ID"],
                                       ENV["GOOGLE_CLIENT_SECRET"],
                                       authorize_url: "/o/oauth2/v2/auth",
                                       site: ENV["GOOGLE_OAUTH_IDP_URL"],
                                       token_url: ENV["GOOGLE_OAUTH_API_URL"],
                                       redirect_uri: ENV["GOOGLE_OAUTH_REDIRECT_URL"])

      decoded_access_code = CGI.unescape(access_code)
      @token = @client.auth_code.get_token(decoded_access_code, redirect_uri: ENV["GOOGLE_OAUTH_REDIRECT_URL"])

      # 발급한 토큰으로  프로필 조회 API 호출 후 유저 정보를 가져온다.
      @user_info = JSON.parse(Faraday.get(ENV["GOOGLE_USER_INFO_API_URL"], {}, { "Authorization" => "Bearer #{@token.token}", "Content-Type" => "application/json" }).body)

      user_email = @user_info["email"]
      user_name = generate_nickname
      user_id = @user_info["id"]

      @user = User.by_login_type(login_type.downcase).by_social_id(user_id).last

      if @user.nil?
        @user = User.create!(login_type: login_type.downcase, nickname: user_name, email: user_email, is_complete_tutorial: "N", status: "10", social_id: user_id)
      end

      { access_token: access_token, refresh_token: refresh_token }

    when "NAVER"
      # 네이버 로그인 로직
      # 인가 코드 받은 걸로 접근 토큰을 발급한다.
      @client = OAuth2::Client.new(ENV["NAVER_CLIENT_ID"],
                         ENV["NAVER_CLIENT_SECRET"],
                         authorize_url: "/oauth2.0/authorize",
                         site: ENV["NAVER_OAUTH_IDP_URL"],
                         token_url: "/oauth2.0/token",
                         redirect_uri: ENV["NAVER_OAUTH_REDIRECT_URL"])

      # 네이버 토큰 발급
      @token = @client.auth_code.get_token(access_code, redirect_uri: ENV["NAVER_OAUTH_REDIRECT_URL"])

      # 발급한 토큰으로 네이버 유저 프로필 조회 API 호출 후 유저 정보를 가져온다.
      @user_info = JSON.parse(Faraday.get(ENV["NAVER_USER_INFO_API_URL"], {}, { "Authorization" => "Bearer #{@token.token}", "Content-Type" => "application/json" }).body)

      user_email = @user_info["response"]["email"]
      user_name = generate_nickname
      user_id = @user_info["response"]["id"]

      @user = User.by_login_type(login_type.downcase).by_social_id(user_id).last

      if @user.nil?
        @user = User.create!(login_type: login_type.downcase, nickname: user_name, email: user_email, is_complete_tutorial: "N", status: "10", social_id: user_id)
      end

      { access_token: access_token, refresh_token: refresh_token }

    else
      # type code here
    end
  end

  private
    def access_token
      compose(Users::CreateJsonWebTokenService, user: @user, type: "ACCESS_TOKEN")
    end

    def refresh_token
      compose(Users::CreateJsonWebTokenService, user: @user, type: "REFRESH_TOKEN")
    end

    def generate_nickname
      while true
        @nickname = RandomNickname::Generator.generate
        # 닉네임이 존재하지 않는다면 반복문 종료
        unless User.by_nickname(@nickname).present?
          break
        end
      end
      @nickname
    end
end
