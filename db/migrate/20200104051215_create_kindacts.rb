class CreateKindacts < ActiveRecord::Migration[5.0]
  def change
    create_table :kindacts do |t|
      t.string :description
      t.string :reflection
      t.boolean :completion
      t.timestamps
    end 
  end
end
