RSpec.configure do |config|
  config.before(type: :request) do
    def parsed_body
      return {} if response&.body.blank?
      parsed_body = JSON.parse(response.body)
      parsed_body.respond_to?(:symbolize_keys) ? parsed_body.symbolize_keys : parsed_body.map(&:symbolize_keys)
    end
  end
end
