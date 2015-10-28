class ModifyTestResultResponseCodes < ActiveRecord::Migration
  def change
    add_column :test_result_response_codes, :number_of_times, :integer, :after => :response_code
  end
end
