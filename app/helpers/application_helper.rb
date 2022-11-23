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

  def form_reveal_list(form, field, target)
    form.input field.to_sym, input_html: { data: { reveal_target: target } }
  end

  def form_reveal_song(form, field, target)
    form.input field, input_html: { data: { reveal_target: target },
                                    value: form_word_wrap(@song[field]),
                                    cols: '70',
                                    rows: '10' }
  end
end
