module ApplicationHelper
  def map_locale_names(locale)
    I18n.available_locales.to_h { |lang| [t("languages.#{lang}", locale: locale), lang] }
  end

  def translater(target)
    I18n.available_locales.to_h { |lang| [lang, "#{target}_#{lang}".to_sym] }
  end

  def form_word_wrap(text, line_width: 80, break_sequence: "\n")
    text.split("<br/><br/>").collect! do |line|
      line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1#{break_sequence}").rstrip : line
    end * break_sequence
  end
end
