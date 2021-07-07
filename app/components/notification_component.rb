# frozen_string_literal: true

# @param type [String] Classic notification type `error`, `alert` and `info` + custom `success`
# @param data [String, Hash] `String` for backward compatibility,
#   `Hash` for the new functionality `{title: '', body: '', timeout: 5, countdown: false, action: { url: '', method: '', name: ''}}`.
#   The `title` attribute for `Hash` is mandatory.
class NotificationComponent < ViewComponent::Base
  def initialize(type:, data:)
    @type = type
    @data = prepare_data(data)
    @icon_class = icon_class
    @icon_color_class = icon_color_class

    @data[:timeout] ||= 3
    @data[:action][:method] ||= "get" if @data[:action]
  end

  private

  def icon_class
    case @type
    when 'success'
      'fa-check-circle'
    when 'error'
      'fa-exclamation-triangle'
    when 'alert'
      'fa-exclamation-circle'
    else
      'fa-info-circle'
    end
  end

  def icon_color_class
    case @type
    when 'success'
      'text-green-400'
    when 'error'
      'text-red-800'
    when 'alert'
      'text-red-400'
    else
      'text-gray-400'
    end
  end

  def prepare_data(data)
    case data
    when Hash
      data.deep_symbolize_keys
    else
      { title: data }
    end
  end
end
