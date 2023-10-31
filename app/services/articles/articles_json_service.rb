class ArticlesJsonService < ArticlesBaseService
    def initialize(json_params)
        @json = json_params.tempfile
    end

    def call
        Article.import articles_from(@json), ignore: true
    end

    def articels_from(json)
    end

end