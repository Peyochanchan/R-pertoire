module ApplicationHelper
  def map_locale_names(locale)
    I18n.available_locales.to_h { |lang| [t("languages.#{lang}", locale: locale), lang] }
  end

  def translater(target)
    I18n.available_locales.to_h { |lang| [lang, "#{target}_#{lang}".to_sym] }
  end
end
