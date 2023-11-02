class AddLanguageColumnToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :language, :string, default: "russian"
  end
end
