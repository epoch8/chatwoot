class AddSearchableColumnToArticles < ActiveRecord::Migration[7.0]
  def up 
    execute <<-SQL
      ALTER TABLE articles
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('simple', coalesce(title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(content,'')), 'B') || 
        setweight(to_tsvector('simple', coalesce(description,'')), 'C')
      ) STORED;
    SQL
  end

  def down
    remove_column :articles, :searchable
  end
end
