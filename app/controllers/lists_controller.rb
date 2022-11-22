class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_params, only: %i[show edit update destroy]

  def index
    @lists = policy_scope(List).order(public: :asc)
    @songs = policy_scope(Song).order(public: :asc)
  end

  def show
    authorize @list
  end

  def new
    @list = List.new
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
                                 :user_id)
  end
end
