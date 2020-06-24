class GoogleAPI
  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  CREDENTIALS_PATH = "./app/services/google_api/credentials.json".freeze

  TOKEN_PATH = "./app/services/google_api/token.yaml".freeze
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

  def authorize
    config = {
      installed: {
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET']
      }
    }

    client_id = Google::Auth::ClientId.from_hash JSON.parse config.to_json
    token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    credentials = authorizer.get_credentials :default
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code user_id: :default, code: code, base_url: OOB_URI
    end
    credentials
  end
end
