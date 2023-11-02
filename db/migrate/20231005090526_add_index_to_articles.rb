class AddIndexToArticles < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :articles, [:title, :content], opclass: :gin_trgm_ops, using: :gin, algorithm: :concurrently
  end
end
