module Openai
  class ApiResponseService < BaseService
    def call(input)
      body = build_body(input)
      response = post_request(url: '/v1/chat/completions', body: body)
      extract_message_content(response)
    end

    private

    def build_body(input)
      {
        model: @model,
        messages: [
          { role: "system", content: "You are professional chef." },
          { role: "user",
            content:
              "Please provide a recipe for a side dish for a lunchbox with the following conditions.

              # conditions
              Ingredients: #{array_tag(input)}
              Taste: #{input[:taste]} style
              Cooking time: #{input[:time_required]}
              Plese answer in Japanese.
              Output should be less than 300 tokens

              # output
              タイトル:(no break)
              材料(一人前):(no more than 6)
              手順:(only 3 steps)"
          }
        ]
      }.to_json
    end

    def array_tag(params)
      tag_ids = params[:tag_ids].reject(&:blank?)
      tag_ids.map{ |id| Tag.find(id).name }.join(',')
    end


    def extract_message_content(response)
      response_hash = JSON.parse(response.body)
      content = response_hash.dig("choices", 0, "message", "content")
      raise StandardError, 'レシピの情報が取得できませんでした' unless content.present?

      content
    rescue JSON::ParserError
      raise StandardError, 'レシピの情報が取得できませんでした。'
    end
  end
end