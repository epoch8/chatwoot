class AddIntentToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :intent, :string
  end
end
