# app/services/response_service.rb
class ResponseService
  # Successful response with data and pagination metadata
  def self.success(data, meta = nil)
    if meta
      { data: data, meta: meta }
    else
      { data: data }
    end
  end

  # Error response
  def self.error(code, message)
    { error: { code: code, message: message } }
  end
end
