class LoadTestSchedule < ActiveRecord::Base
  belongs_to :load_test

  validates :maximum_virtual_users, numericality: {only_integer: true, greater_than: -1}
  validates :duration, numericality: {only_integer: true, greater_than: 0}
end