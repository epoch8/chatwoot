class ArticlesImport::ArticlesXlsxImportService < ArticlesImport::BaseArticlesImportService
  require 'rubyXL'

  def initialize(xlsx_param, portal)
    @xlsx = xlsx_param.tempfile
    @portal = portal
  end

  def call
    result = articles_from(@xlsx, @portal)
    Rails.logger.info result
    if result.nil?
      raise "Invalid table schema"
    end
    Article.import(result, ignore: false)
  end

  private

  def articles_from(xlsx, portal)
    sheet = RubyXL::Parser.parse(xlsx)[0]
    articles = Array.new
    sheet.drop(1).map do |row|
      cells = row.cells

      title = cells[0].value
      content = cells[1].value
      questions = cells[2].value
      author_id = cells[3].value
      category_id = cells[4].value
      next if title.nil? and content.nil? and author_id.nil? and category_id.nil? and  questions.nil?
      return if title.nil? or content.nil? or author_id.nil? or category_id.nil?

      article = portal.articles.new(
        title: cells[0].value,
        content: cells[1].value,
        author_id: cells[3].value,
        category_id: cells[4].value,
        status: 1,
      )
      unless questions.nil?
        questions.split(';').map do |question|
          article.questions.new(content: question)
        end
      end
      articles.push(article)
    end
    return articles
  end
end
