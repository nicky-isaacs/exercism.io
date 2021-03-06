class UserExercise < ActiveRecord::Base
  has_many :submissions, ->{ order 'created_at ASC' }

  # I don't really want the notifications method,
  # just the dependent destroy
  has_many :notifications, ->{ where(item_type: 'UserExercise') }, dependent: :destroy, foreign_key: 'item_id', class_name: 'Notification'

  belongs_to :user

  scope :active,    ->{ where(state: ['pending', 'needs_input', 'hibernating']) }
  scope :completed, ->{ where(state: 'done') }

  before_create do
    self.key = generate_key
  end

  def name
    @name ||= slug.split('-').map(&:capitalize).join(' ')
  end

  def track_id
    language
  end

  # close & reopen:
  # Once v1.0 is launched we can ditch
  # the state on submission.
  def close!
    update_attributes(state: 'done')
    submissions.last.update_attributes(state: 'done')
  end

  def closed?
    state == 'done'
  end

  def reopen!
    update_attributes(state: 'pending')
    submissions.last.update_attributes(state: 'pending')
  end

  def open?
    state == 'pending'
  end

  def unlock!
    update_attributes(is_nitpicker: true)
  end

  def generate_key
    Digest::SHA1.hexdigest(secret)[0..23]
  end

  def completed?
    state == 'done'
  end

  def hibernating?
    state == 'hibernating'
  end

  def nit_count
    submissions.pluck(:nit_count).sum
  end

  private

  def secret
    if ENV['USER_EXERCISE_SECRET']
      "#{ENV['USER_EXERCISE_SECRET']} #{rand(10**10)}"
    else
      "There is solemn satisfaction in doing the best you can for #{rand(10**10)} billion people."
    end
  end
end
