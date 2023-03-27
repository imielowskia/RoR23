class CreateGrades < ActiveRecord::Migration[7.0]
  def change
    create_table :grades do |t|
      t.references :course, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.decimal :ocena, precision: 3, scale: 1
      t.date :data

      t.timestamps
    end
  end
end
