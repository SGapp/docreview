# encoding: utf-8

require "rexml/document"

module Abby

  class Doc
    attr_reader :recognized_text
    def initialize(path)
      @file_name = path
      @language_choice = "French"

      read_text
    end

    private

    APPLICATION_ID = CGI.escape("DocReview")

    PASSWORD = CGI.escape("/3849zrVA7Yuc+Yz24Xfev46")

    BASE_URL = "http://#{APPLICATION_ID}:#{PASSWORD}@cloud.ocrsdk.com"

    def output_response_error(response)
      xml_data = REXML::Document.new(response)
      error_message = xml_data.elements["error/message"]
    end

    def read_text
      begin
        response = RestClient.post("#{BASE_URL}/processImage?language=#{@language_choice}&exportFormat=txt", :upload => {
          :file => File.new(@file_name, 'rb')
        })
      rescue RestClient::ExceptionWithResponse => e
        output_response_error(e.response)
        raise
      else
        xml_data = REXML::Document.new(response)
        task_element = xml_data.elements["response/task"]
        task_id = task_element.attributes["id"]
        task_status = task_element.attributes["status"]
      end


      while task_status == "InProgress" or task_status == "Queued" do
        begin
          sleep(5)
          response = RestClient.get("#{BASE_URL}/getTaskStatus?taskid=#{task_id}")
        rescue RestClient::ExceptionWithResponse => e
          output_response_error(e.response)
          raise
        else
          xml_data = REXML::Document.new(response)
          task_element = xml_data.elements["response/task"]
          task_status = task_element.attributes["status"]
        end
      end

      raise "The task hasn't been processed because an error occurred" if task_status == "ProcessingFailed"

      raise "You don't have enough money on your account to process the task" if task_status == "NotEnoughCredits"

      download_url = xml_data.elements["response/task"].attributes["resultUrl"]
      @recognized_text = RestClient.get(download_url)

      puts @recognized_text

      @recognized_text.force_encoding("UTF-8")

    end

   end

end