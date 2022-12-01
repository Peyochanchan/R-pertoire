class ListSongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_params, only: %i[show new edit update destroy move]

  def index
    @list_songs = policy_scope(ListSong)
  end

  def show
    authorize @list_song
  end

  def new
    @list_song = ListSong.new
    @list = List.find(params[:list_id])
    @songs = Song.policy_scope(Song)
    @list_song.user = current_user
    authorize @list_song
  end

  def create
    @list = List.find(params[:list_id])
    @list_song = ListSong.new(list_song_params)
    @list_song.list = @list
    @list_song.position = @list.list_songs.length + 1
    authorize @list_song
    respond_to do |format|
      if @list_song.save
        format.html { redirect_to list_path(@list, anchor: "lsong-#{@list_song.id}"), notice: "ListSong was successfully created." }
        format.json
      else
        format.html { redirect_to list_path(@list), status: :unprocessable_entity }
        format.json { render json: @list_song.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @list_song
  end

  def update
    @list = List.find(params[:list_id])
    @list_song.update(list_id: @list.id)
    authorize @list_song
    respond_to do |format|
      if @list_song.update(list_song_params)
        format.html { redirect_to list_path(@list_song.list.id), notice: 'List Song was successfully updated.' }
        format.json { redirect_to list_path(@list), status: :created, location: @list_song }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list_song.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    authorize @list_song
    @list_song.destroy
    respond_to do |format|
      format.html { redirect_to list_url(@list), notice: 'List Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    @list = List.find(params[:list_id])
    @list_songs = @list.list_songs
    ListSong.destroy(params[:list_songs])
    authorize @list_songs, :destroy_multiple?
    redirect_to @list
  end

  def move
    @list_song = ListSong.find(params[:id])
    @list = List.find(params[:list_id])
    @list_songs = @list.list_songs
    @list_song.insert_at(params[:position].to_i)
    @list_songs.each_with_index { |l, i| l.update(position: i + 1) }
    authorize @list_song, :move?
    head :ok
  end

  private

  def set_params
    @list_song = ListSong.find(params[:id])
  end

  def list_song_params
    params.require(:list_song).permit(:list_id, :song_id, :position, :tonality, song_ids: [])
  end
end
