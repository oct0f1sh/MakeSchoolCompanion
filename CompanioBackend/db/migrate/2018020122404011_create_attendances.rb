class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.string :name, unique: true
      t.string :in_time
      t.string :out_time

      t.timestamps
    end
  end
end
