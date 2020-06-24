require 'byebug'
require 'gemoji'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

require './lib/emoji_extension.rb'
require './app/services/google_api.rb'

class Sheets
  include EmojiExtension

  def service
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = GoogleAPI.new.authorize
    service
  end

  def create(title, sheet_tabs)
    spreadsheet = {
      properties: {
        title: title
      },
      sheets: sheet_tabs.collect { |sheet| { properties: { title: sheet } } }
    }

    spreadsheet = service.create_spreadsheet spreadsheet, fields: 'spreadsheetId'
    puts "\n#{emoji_check_mark} The spreadsheet has been created!"
    puts "Spreadsheet ID: #{spreadsheet.spreadsheet_id}"

    spreadsheet.spreadsheet_id
  end

  def add_sheet(spreadsheet_id, sheet_name)
    requests = [
      add_sheet: {
        properties: {
          title: sheet_name
        }
      }
    ]

    begin
      request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new requests: requests
      service.batch_update_spreadsheet spreadsheet_id, request
      puts "\n#{emoji_check_mark} The sheet named '#{sheet_name}' has been added!"
      true
    rescue Google::Apis::ClientError
      puts "\n#{emoji_x_mark} Failed to add the sheet named '#{sheet_name}'!"
      false
    end
  end

  def write(spreadsheet_id, range, values)
    value_range_object = Google::Apis::SheetsV4::ValueRange.new values: values
    result = service.update_spreadsheet_value spreadsheet_id, range, value_range_object, value_input_option: 'RAW'

    puts "\n#{emoji_check_mark} #{result.updated_cells} cells updated."
  end
end
