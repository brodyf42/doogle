class CreateDefinitions < ActiveRecord::Migration[6.1]
  def change
    create_table :definitions do |t|
      t.integer :entry_id
      t.text :text
      t.timestamps
    end
  end
end
