class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :description
      t.string :reflection
      t.boolean :completion
      t.integer :user_id
      t.integer :kindact_id
      t.integer :recipient_id
      t.timestamps
    end 
  end
end
