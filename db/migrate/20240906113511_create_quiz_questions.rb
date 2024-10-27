class CreateQuizQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_questions do |t|
      t.text :question
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :option4
      t.string :correct_answer

      t.timestamps
    end
  end
end
