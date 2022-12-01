module SongsHelper
  def form_reveal_song(form, field, target)
    form.input field, input_html: { data: { reveal_target: target },
                                    value: form_word_wrap(@song[field]),
                                    cols: '70',
                                    rows: '10' }
  end
end
