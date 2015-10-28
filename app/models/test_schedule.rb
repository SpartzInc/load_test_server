class TestSchedule < ActiveRecord::Base
  belongs_to :load_test
  validates :load_test, :presence => true

  has_one :test_result, :dependent => :destroy

  #Schedule the test
  after_create :schedule_test

  scope :load_test_filter, -> (name) {
    joins(:load_test).where('name = ?', name)
  }

  def status
    case
      when self.cancelled?
        return :cancelled
      when self.failed?
        return :failed
      when self.complete?
        return :complete
      when self.started?
        return :in_progress
      else
        return :waiting
    end
  end

  def run_test_at
    return Time.now if self.schedule_now?
    return self.schedule_at
  end

  def schedule_test
    Delayed::Job.enqueue TestJob.new(self), :run_at => Proc.new { |i| i.run_test_at }
  end

  def formatted_name
    return self.load_test.name + ' - ' + self.created_at.to_s
  end

  def cancel
    if self.cancelled?
      return 'Test schedule has already been cancelled'
    elsif self.complete?
      return 'Test schedule has already been completed'
    else
      Rails.cache.write(:cancel_load_test, self.id)

      self.cancelled = true
      self.save
      return 'Test schedule has been cancelled'
    end
  end
end
