class Api::V1::Accounts::ArticlesController < Api::V1::Accounts::BaseController
  before_action :portal
  before_action :check_authorization
  before_action :fetch_article, except: [:index, :create, :attach_file, :reorder, :import_from_file]
  before_action :set_current_page, only: [:index]

  include Sift

  sort_on :title, internal_name: :order_by_title, type: :scope, scope_params: [:direction]
  sort_on :updated_at, internal_name: :order_by_updated_at, type: :scope, scope_params: [:direction]
  sort_on :position, internal_name: :order_by_position, type: :scope, scope_params: [:direction]
  sort_on :category, internal_name: :order_by_category, type: :scope, scope_params: [:direction]

  def index
    @portal_articles = @portal.articles
    @all_articles = @portal_articles.search(list_params)
    @articles_count = @all_articles.count

    @articles = filtrate(@all_articles).page(@current_page)

    # @articles = if list_params[:category_slug].present?
    #               @all_articles.order_by_position.page(@current_page).per(50)
    #             else
    #               @all_articles.order_by_updated_at.page(@current_page)
    #             end
  end

  def import_from_file
    render json: { error: "File not found!" }, status: :unprocessable_entity and return if params[:file].blank?
    file = params[:file]
    if file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      begin
        ::ArticlesImport::ArticlesXlsxImportService.call(file, @portal)
      rescue StandardError => e
        render json: {error: e}, status: :unprocessable_entity
      end
    end
  end

  def show; end
  def edit; end

  def create
    @article = @portal.articles.create!(article_params)
    @article.associate_root_article(article_params[:associated_article_id])
    @article.draft!
    render json: { error: @article.errors.messages }, status: :unprocessable_entity and return unless @article.valid?
  end


  def update
    @article.update!(article_params) if params[:article].present?
    render json: { error: @article.errors.messages }, status: :unprocessable_entity and return unless @article.valid?
  end

  def destroy
    @article.destroy!
    head :ok
  end

  def attach_file
    file_blob = ActiveStorage::Blob.create_and_upload!(
      key: nil,
      io: params[:background_image].tempfile,
      filename: params[:background_image].original_filename,
      content_type: params[:background_image].content_type
    )
    file_blob.save!
    render json: { file_url: url_for(file_blob) }
  end

  def reorder
    Article.update_positions(params[:positions_hash])
    head :ok
  end

  private

  def fetch_article
    @article = @portal.articles.find(params[:id])
  end

  def portal
    @portal ||= Current.account.portals.find_by!(slug: params[:portal_id])
  end


  def article_params
    params.require(:article).permit(
      :title, :slug, :position, :language, :intent, :content, :description, :position, :category_id, :author_id, :associated_article_id, :status, meta: [:title,
                                                                                                                                     :description,
                                                                                                                                     { tags: [] }], questions: [ :content]
    )
  end

  def list_params
    params.permit(:locale, :title, :content, :page, :category_slug, :status, :author_id)
  end

  def set_current_page
    @current_page = params[:page] || 1
  end
end
