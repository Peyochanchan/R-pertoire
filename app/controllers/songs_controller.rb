class SongsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_params, only: %i[show edit update destroy]
  include GoogleApi

  def index
    @songs = policy_scope(Song)
  end

  def show
    detect_language(@song.lyrics)
    authorize @song
  end

  def new
    @song = Song.new
    authorize @song
  end

  def create
    @song = Song.new(song_params)
    @song.user = current_user
    authorize @song
    translation(@song, 'lyrics')
    translation(@song, 'title')
    respond_to do |format|
      if @song.save
        format.html { redirect_to song_url(@song), notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @song
    # raise
  end

  def update
    authorize @song
    translate_again(@song, %w[title lyrics])
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to song_path(@song), notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @song
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_params
    @song = Song.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:title,
                                 :lyrics,
                                 :public,
                                 :lyrics_ar,
                                 :lyrics_en,
                                 :lyrics_es,
                                 :lyrics_fr,
                                 :lyrics_nb,
                                 :title_ar,
                                 :title_en,
                                 :title_es,
                                 :title_fr,
                                 :title_nb,
                                 :composer,
                                 :user_id)
  end
end
