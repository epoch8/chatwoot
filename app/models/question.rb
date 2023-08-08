# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  content    :text
#  article_id :bigint           not null
#
# Indexes
#
#  index_questions_on_article_id  (article_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#



class Question < ApplicationRecord
    validates :content, presence: true, length: {minimum:3, maximum:512}
    belongs_to :article
end
