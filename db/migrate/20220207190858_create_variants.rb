class CreateVariants < ActiveRecord::Migration[6.1]
  def change
    create_table :variants do |t|
      t.integer :word_id
      t.text :name
      t.timestamps
    end
  end
end
