json.content format_content(@song.lyrics)
json.call(:title, :composer, :lyrics, :public, :user_id)
