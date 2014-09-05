# encoding: utf-8

require "rexml/document"

class Abby

  application_id = CGI.escape(ENV['APPLICATION_ID'])

  password = CGI.escape(ENV['PASSWORD'])

  BASE_URL = "http://#{application_id}:#{password}@cloud.ocrsdk.com"

  def initialize(path)
    @file_name = path
    @language_choice = "French"
  end

  def content
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
    doc_content = RestClient.get(download_url)

    doc_content.force_encoding("UTF-8")

  end

  private

  def output_response_error(response)
    xml_data = REXML::Document.new(response)
    error_message = xml_data.elements["error/message"]
  end

end
