class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :indeks, limit: 6
      t.string :imie, limit: 15
      t.string :nazwisko, limit: 25
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
