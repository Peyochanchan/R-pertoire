if @list_song.persisted?
  json.form render(partial: 'list_songs/form', formats: :html, locals: { list: @list, list_song: ListSong.new })
  json.inserted_lsong render(partial: 'lists/list_song', formats: :html, locals: { lsong: @list_song })
else
  json.form render(partial: 'list_songs/form', formats: :html, locals: { list: @list, list_song: @list_song.errors })
end
