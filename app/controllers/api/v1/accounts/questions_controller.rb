class Api::V1::Accounts::QuestionsController < Api::V1::Accounts::BaseController
    before_action :set_article!

    def create
        questions = @article.questions.build content
        return questions
    end

    def destroy
        question = Question.find_by id: params[:id]
        if question
            question.destroy
            head :ok
        else
            render json: { error: @question.errors.messages }, status: :not_found
        end
    end

    private

    def question_params
        params.require(:question).permit(:body)
    end

    def set_article!
        @article = Article.find params[:article_id]
    end
end