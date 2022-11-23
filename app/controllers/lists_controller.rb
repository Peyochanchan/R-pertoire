require "open-uri"

class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_params, only: %i[show edit update destroy]
  before_action :update_position, only: :show

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
    @description_translater_hash = I18n.available_locales.to_h { |lang| [lang, "description_#{lang}".to_sym] }
    @name_translater_hash = I18n.available_locales.to_h { |lang| [lang, "name_#{lang}".to_sym] }
    @list.qr_code = RQRCode::QRCode.new(list_url(@list)).as_svg(
      offset: 0,
      color: '000',
      module_size: 5,
      shape_rendering: 'geometricPrecision',
      standalone: true,
      use_path: true
    )
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
    update_list_translation(@list, 'name')
    update_list_translation(@list, 'description')
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
    translate_again(@list)
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

  def translate_again(list)
    update_list_translation(list, 'description') if params[:translate_description]
    update_list_translation(list, 'name') if params[:translate_name]
  end

  def update_list_translation(list, attribute)
    translater_hash = I18n.available_locales.to_h { |lang| [lang, "#{attribute}_#{lang}".to_sym] }
    translate = Google::Cloud::Translate::V2.new(
      key: ENV.fetch('CLIENT_ID')
    )
    list[attribute.to_sym] = params[:list][attribute.to_sym]
    translater_hash.each do |k, v|
      list[v] = translate.translate list[attribute.to_sym].html_safe, to: k.to_s
      list[v] = helpers.sanitize(list[v])
    end
  end

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
                                 :qr_code,
                                 :user_id,
                                 :photo,
                                 song_ids: [])
  end
end
