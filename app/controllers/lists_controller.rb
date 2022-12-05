require 'open-uri'

class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_params, only: %i[show edit update destroy]
  before_action :update_position, only: :show
  include GoogleApi
  include Qrcode

  def index
    @lists = policy_scope(List).order(public: :asc)
    @songs = policy_scope(Song).order(public: :asc)
  end

  def show
    @list_song = ListSong.new
    params[:list_id] = @list.id
    @list_song.list_id = @list.id
    @songs = policy_scope(Song)
    @lsongs = @list.list_songs.order(position: :asc)
    detect_language(@list.description)
    generate_qrcode(@list)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ListPdf.new(@list, @lsongs)
        send_data pdf.render, filename: 'report.pdf', type: 'application/pdf'
      end
    end
    authorize @list
  end

  def new
    @list = List.new
    @list_song = ListSong.new
    params[:list_id] = @list.id
    authorize @list
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    authorize @list
    %w[name description].each { |attribute| translation(@list, attribute) }
    respond_to do |format|
      if @list.save
        format.html { redirect_to list_path(@list), notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @list_song = ListSong.new
    authorize @list
  end

  def update
    authorize @list
    translate_again(@list, %w[description name])
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to list_path(@list), notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @list
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_path, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def update_position
    @list = List.find(params[:id])
    @list.list_songs.each_with_index do |lsong, i|
      lsong.position = i + 1
      lsong.save!
    end
  end

  def set_params
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name,
                                 :name_fr,
                                 :name_en,
                                 :name_es,
                                 :name_ar,
                                 :name_nb,
                                 :description,
                                 :description_fr,
                                 :description_es,
                                 :description_en,
                                 :description_nb,
                                 :description_ar,
                                 :public,
                                 :user_id,
                                 :photo,
                                 :qr_code,
                                 song_ids: [])
  end
end
