module KalturaFu
  
  ##
  # The Report module provides class methods to retrieve analytic information and reports from Kaltura entries.
  #
  # @author Patrick Robertson 
  ##
  module Report
    
    ##
    # Returns an Array of hashes that contains a Kaltura content drop-off report ordered by # of plays descending.
    # Kaltura treats # of plays as a string, so 5 comes before 353.
    #
    # @param [Date] from_date The starting date for the report.  The end date is currently always today.
    # @param [String] video_list a comma delimited list of Kaltura entry_id's to report upon.
    # 
    # @return [Array] An array of Hashes that contains the entry_id, total plays, and then plays for 25%, 50%, 75% and 100% through the content.
    ##
    def generate_report(from_date,video_list)
      hash_array = []
          
      KalturaFu.check_for_client_session
    
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
    
      report_raw = KalturaFu.client.report_service.get_table(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     report_pager,
                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                     video_list)
      unless report_raw.data.nil?
        report_split_by_entry = report_raw.data.split(";")
        report_split_by_entry.each do |row|
          segment = row.split(",")
          row_hash = {}
          row_hash[:entry_id] = segment.at(0)
          row_hash[:plays] = segment.at(2)
          row_hash[:play_through_25] = segment.at(3)
          row_hash[:play_through_50] = segment.at(4)
          row_hash[:play_through_75] = segment.at(5)
          row_hash[:play_through_100] = segment.at(6)
          hash_array << row_hash
        end
    
        hash_array = hash_array.sort{|a,b| b[:plays].to_i <=> a[:plays].to_i}
      end
      hash_array                                              
    end
  
    ##
    # creates a report CSV on the kaltura server and then returns the url to grab it.  Unfortunately the MIME type of the resource is "text/plain"
    # instead of "text/csv" so there isn't a ton you can do with it.
    #
    # @param [Date] from_date The starting date for the report.  The end date is currently always today.
    # @param [String] video_list a comma delimited list of Kaltura entry_id's to report upon.
    #
    # @return [String] URL to grab the report in CSV format.
    ##
    def generate_report_csv_url(from_date,video_list)
      report_title = "TTV Video Report"
      report_text = "I'm not sure what this is"
      headers = "Kaltura Entry,Plays,25% Play-through,50% Play-through, 75% Play-through, 100% Play-through, Play-Through Ratio"
    
      KalturaFu.check_for_client_session
    
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
    
      report_url = KalturaFu.client.report_service.get_url_for_report_as_csv(report_title,
                                                                     report_text,
                                                                     headers,
                                                                     Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                                     report_filter,
                                                                     "",
                                                                     report_pager,
                                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                                     video_list)
      report_url      
    end  
  
    ##
    # Returns a grand total of the plays broken down by content drop-off given a list of Kaltura entries.
    #
    # @param [Date] from_date The starting date for the report.  The end date is currently always today.
    # @param [String] video_list a comma delimited list of Kaltura entry_id's to report upon.
    # 
    # @return [Hash] a list that contains total plays and plays broken down to 25%, 50%, 75%, and 100% through content.
    ##
    def generate_report_total(from_date,video_list)
      row_hash = {}
    
      KalturaFu.check_for_client_session
    
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i      
      report_raw = KalturaFu.client.report_service.get_total(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     video_list)
      unless report_raw.data.nil?
        segment = report_raw.data.split(",")
        row_hash[:plays] = segment.at(0)
        row_hash[:play_through_25] = segment.at(1)
        row_hash[:play_through_50] = segment.at(2)
        row_hash[:play_through_75] = segment.at(3)
        row_hash[:play_through_100] = segment.at(4)                                         
      
        row_hash
      end
    end
  
    ##
    # Returns the total number of Kaltura entries that had any plays during the reporting period.
    #
    # @param [Date] from_date The starting date for the report.  The end date is currently always today.
    # @param [String] video_list a comma delimited list of Kaltura entry_id's to report upon.      
    ##
    def generate_report_video_count(from_date,video_list)
      row_hash = {}
    
      KalturaFu.check_for_client_session
    
      report_filter = Kaltura::Filter::ReportInputFilter.new
      report_filter.from_date = from_date.to_i
      report_filter.to_date = Time.now.utc.to_i
      report_pager = Kaltura::FilterPager.new
      report_pager.page_size = 1000
    
      report_raw = KalturaFu.client.report_service.get_table(Kaltura::Constants::ReportType::CONTENT_DROPOFF,
                                                     report_filter,
                                                     report_pager,
                                                     Kaltura::Constants::Media::OrderBy::PLAYS_DESC,
                                                     video_list)
      unless report_raw.data.nil?                                     
        report_raw.total_count
      end
    end
    
  end
end