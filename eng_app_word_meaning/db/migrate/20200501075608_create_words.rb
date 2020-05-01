class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.integer :sentence_no
      t.string :en
      t.string :note
      t.string :url

      t.timestamps
    end
  end
end
