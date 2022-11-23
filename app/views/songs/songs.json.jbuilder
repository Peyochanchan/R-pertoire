json.content format_content(@song.lyrics)
json.(:title, :composer, :lyrics, :public, :user_id)
