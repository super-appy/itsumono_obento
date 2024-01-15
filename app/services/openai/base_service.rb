module Openai
  class UnauthorizedError < StandardError; end
  class TooManyRequestsError < StandardError; end
  class InternalServerError < StandardError; end
  class ServiceUnavailableError < StandardError; end
  class TimeoutError < StandardError; end

  class BaseService
    attr_reader :model

    def initialize(model: 'gpt-4-1106-preview', timeout: 30)
      @model = model
      @connection = Faraday.new(url: 'https://api.openai.com') do |f|
        f.headers['Authorization'] = "Bearer #{ENV['OPENAI_ACCESS_TOKEN']}"
        f.headers['Content-Type'] = 'application/json'
        f.options[:timeout] = timeout
        f.adapter Faraday.default_adapter
      end
    end

    protected

    def post_request(url: '/', body: '{}')
      response = @connection.post(url) { |req| req.body = body }
      handle_response_errors(response)
      response
    rescue Faraday::TimeoutError
      raise TimeoutError, 'リクエストがタイムアウトしました。もう一度お試しください。'
    end


    private

    def handle_response_errors(response)
      case response.status
      when 200  # 何もしない
      when 401
        raise UnauthorizedError, '認証エラーが発生しました。管理者までお問い合わせください。。'
      when 429
        raise TooManyRequestsError, 'リクエストの制限を超えました。しばらく時間をおいてから再度お試しください。'
      when 500
        raise InternalServerError, 'サーバー内部でエラーが発生しました。しばらく時間をおいてから再度お試しください。'
      when 503
        raise ServiceUnavailableError, 'サービスが利用不可です。しばらく時間をおいてから再度お試しください。'
      else
        raise StandardError, '予期せぬエラーが発生しました。もう一度お試しいただくか、管理者までお問い合わせください。'
      end
    end

    def extract_message(response_body)
      extracted_message = begin
                            response_json = JSON.parse(response_body)
                            response_json.is_a?(Hash) ? response_json.dig("error", "message") : nil                            response_json.dig("error", "message")
                          rescue JSON::ParserError
                            nil
                          end
      extracted_message || 'エラーが発生しましたが、エラーメッセージが取得できませんでした。'
    end
  end
end
