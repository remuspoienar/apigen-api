module RequestHelper
  def json
    body = JSON.parse(response.body, :quirks_mode => true) rescue {parsing: 'failed'}
    body = body.symbolize_keys if body.is_a?(Hash)
    body.map(&:symbolize_keys) if body.is_a?(Array)
    body
  end
end