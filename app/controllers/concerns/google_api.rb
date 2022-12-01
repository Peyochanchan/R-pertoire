# frozen_string_literal: true

# qr_code for exporting the list
module GoogleApi
  extend ActiveSupport::Concern

  def translation(record, attribute)
    translater_hash = I18n.available_locales.to_h { |lang| [lang, "#{attribute}_#{lang}".to_sym] }
    translate = Google::Cloud::Translate::V2.new(
      key: ENV.fetch('CLIENT_ID')
    )
    if attribute == 'lyrics'
      record.lyrics = params[record.class.name.downcase][:lyrics].gsub!(%r{\r|\n|(<br/>)|(<br><br>)|(<br/><br/>)}, '<br/>')
    else
      record[attribute.to_sym] = params[record.class.name.downcase][attribute.to_sym]
    end
    translater_hash.each do |k, v|
      record[v] = translate.translate record[attribute.to_sym].html_safe, to: k.to_s
    end
  end

  def translate_again(record, attributes = [])
    attributes.each do |attribute|
      translation(record, attribute) if params["translate_#{attribute}".to_sym]
    end
  end

  def detect_language(target)
    translate = Google::Cloud::Translate::V2.new(
      key: ENV.fetch('CLIENT_ID')
    )
    detection = translate.detect target
    @same_language = detection.language == locale.to_s
  end
end
