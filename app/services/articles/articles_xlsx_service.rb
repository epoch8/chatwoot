class ArticlesXlsxService < ArticlesBaseService
    def initialize(xlsx_param)
        @xlsx = xlsx_param.tempfile
    end

    def call
        Article.import articles_from(@xlsx), ignore: true
    end

    private

    def articels_from(xlsx)
        sheet = RubyXL::Parse.parse(xlsx)[0]
        sheet.map do |row|
            cells = row.cells
            article = Article.new title: cells[0].value,
                        content: cells[1].value,
            questions = cells[2].value
            questions.split(';').map do question
                article.Question.new content: question
        end
    end
end