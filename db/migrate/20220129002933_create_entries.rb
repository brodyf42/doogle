class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.integer :word_id
      t.text :function
      t.timestamps
    end
  end
end
