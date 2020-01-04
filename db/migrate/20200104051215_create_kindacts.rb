class CreateKindacts < ActiveRecord::Migration[5.0]
  def change
    create_table :kind_acts do |t|
      t.string :description
      t.timestamps
    end 
  end
end
