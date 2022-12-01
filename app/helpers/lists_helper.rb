module ListsHelper
  def form_reveal_list(form, field, target)
    form.input field.to_sym, input_html: { data: { reveal_target: target } }
  end
end
