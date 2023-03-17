class AddOcenaToCourseStudent < ActiveRecord::Migration[7.0]
  def change
    rename_table 'courses_students', 'course_students'
    add_column :course_students, :ocena, :decimal, precision: 2, scale: 1
  end
end
