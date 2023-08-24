class Api::V1::Accounts::QuestionsController < Api::V1::Accounts::BaseController
    before_action :set_article!
    before_action :set_questions!

    def index; end

    def create
        questions = @article.questions.create!(question_params)
        return questions
    end

    def destroy
        question = Question.find_by id: params[:id]
        if question
            question.destroy
        else
            render json: { error: @question.errors.messages }, status: :not_found
        end
    end

    def show; end

    private

    def question_params
        params.require(:question).permit(:body)
    end

    def set_article!
        @article = Article.find params[:article_id]
    end

    def set_questions!
        @questions = @article.questions.order(:id)
    end

    def question_params
        params.require(:question).permit(:content)
    end
end