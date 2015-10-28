class CreateTestResults < ActiveRecord::Migration
  def change
    create_table :test_results do |t|
      t.belongs_to :test_schedule, index: true
      t.boolean :in_progress

      t.timestamps
    end
  end
end
