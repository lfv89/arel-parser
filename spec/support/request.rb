RSpec.configure do |config|
  config.before(type: :request) do
    def parsed_body
      return {} if response&.body.blank?
      JSON.parse(response.body).symbolize_keys
    end
  end
end
