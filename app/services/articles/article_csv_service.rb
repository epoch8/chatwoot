class ArticlesXlsxService < ArticlesBaseService
    require 'csv'
    
    def initialize(csv_param)
        @csv = csv_param.tempfile
    end

    def call
        Article.import articles_from(@csv), ignore: true
    end

    private

    def articels_from(csv)
        csv = CSV.parse(@csv, :headers => true)
        csv.map do |row|
            
        end
    end
end