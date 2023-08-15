class AddStartMessageToWebWidget < ActiveRecord::Migration[6.1]
  def change
    add_column :channel_web_widgets, :start_message, :string, default: '/get_started'
  end
end
