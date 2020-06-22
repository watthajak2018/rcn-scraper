require 'byebug'
require 'colorize'
require 'gemoji'
require 'nokogiri'
require 'open-uri'

require './lib/emoji_extension.rb'
require './app/services/scraper/thailand/jobs_db.rb'
require './app/services/google_api/sheets.rb'

class Scraper
  include EmojiExtension

  attr_accessor :options, :jobs, :record_count, :skipped_record_count, :table

  def initialize(options)
    @jobs = []
    @options = options
    @record_count = 0
    @skipped_record_count = 0
    @table = []
  end

  def scrape
    puts "\n#{emoji('cloud')}  Scrape job form \"#{@options[:title]}\"\n"

    job_last_page.times do |page|
      pagination_url = [@options[:base_url], @options[:param], page].join

      puts "\n#{emoji('triangular_flag_on_post')} Page: #{page + 1} of #{job_last_page}"
      puts "#{pagination_url}\n\n"

      parsed_page = scrape_page pagination_url
      job_listings = scrape_content parsed_page, @options[:job][:wrapper]

      build_jobs job_listings
    end

    puts "\n#{emoji_circle} Total: #{@record_count} Records."
    puts "#{emoji_x_mark} Skipped: #{@skipped_record_count} Records."
    puts "\n#{emoji('sparkles')} Completed: #{@jobs.count} Jobs."
  end

  def build_jobs(job_listings)
    job_listings.each do |job_listing|
      job = build_job job_listing

      if job.values.compact.reject { |item| item.empty? }.empty?
        @skipped_record_count += 1
      else
        @jobs << job
        puts "#{emoji_check_mark} #{job[:job_title]}\n"
      end

      @record_count += 1
    end
  end

  def build_job(job_listing)
    @options[:jobs].each_with_object({}) { |(key, value), obj| obj[key] = scrape_content job_listing, value }
  end

  def scrape_page(url)
    Nokogiri::HTML URI.open url
  end

  def scrape_content(parsed_page, attr)
    case attr[:type]
    when :container
      parsed_page.css attr[:selector]
    when :text
      parsed_page.css(attr[:selector])&.text
    when :href
      parsed_page.css(attr[:selector]).attr('href')&.value
    end
  end

  def job_last_page
    parsed_page = scrape_page @options[:base_url]
    job_listings = scrape_content(parsed_page, @options[:job][:wrapper])
    per_page = job_listings.count

    (job_total.to_f / per_page.to_f).round
  end

  def job_total
    parsed_page = scrape_page @options[:base_url]
    scrape_content(parsed_page, @options[:job][:total])
  end

  def table_header
    table_header = [:no] + @options[:jobs].keys
    table_header.map { |str| str.to_s.split('_').collect(&:capitalize).join(' ') }
  end

  def sheets_format
    @table << table_header
    @jobs.each.with_index(1) do |job, index|
      table_record = [index] + @options[:jobs].keys.map { |str| job[str.to_sym] }
      @table << table_record
    end
  end

  # def sheets_create
  #   sheet_name = Date.today.strftime '%B %d'
  #   spreadsheet_id = Sheets.new.create "REERACOEN (Jobs Scraper) - #{@options[:title]} (#{Date.today.year})",
  #                     [sheet_name]
  #   Sheets.new.write spreadsheet_id, ["#{sheet_name}!A1"], @table
  # end

  def sheets_write
    spreadsheet_id = ENV['SPREADSHEET_ID']
    sheet_name = Date.today.strftime '%B %d'

    sheet_added = Sheets.new.add_sheet spreadsheet_id, sheet_name
    Sheets.new.write spreadsheet_id, ["#{sheet_name}!A1"], @table if sheet_added
  end
end

scraper = Scraper.new Thailand::JobsDB::DEFAULT_OPTIONS
scraper.scrape
scraper.sheets_format

# scraper.sheets_create
scraper.sheets_write
