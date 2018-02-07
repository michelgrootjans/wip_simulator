class Story
  attr_reader :expected_work
  attr_accessor :name

  def initialize
    @expected_work = {development: 1}
    @actual_work = Hash.new(0)
  end

  def expected_work=(work)
    @expected_work = work
    @actual_work = Hash.new(0)
  end

  def work_types
    @expected_work.keys
  end

  def todo?
    work_types.all? do |type|
      @actual_work[type] == 0
    end
  end

  def in_progress?
    !todo? && !done?
  end

  def done?
    work_types.all? do |type|
      @actual_work[type] >= expected_work[type]
    end
  end

  def do_work(type)
    @actual_work[type] += 1 if ready_for?(type) || in_progress_for?(type)
  end

  def ready_for?(work_type)
    @expected_work.each do |type, value|
      return @actual_work[work_type] == 0 if(type == work_type)
      return false if(@actual_work[type] < @expected_work[type])
    end
    raise 'unexpected code reached'
  end

  def in_progress_for?(type)
    @actual_work[type] > 0 && !done_for?(type)
  end

  def done_for?(type)
    @expected_work[type] <= @actual_work[type]
  end

  def to_json
    { name: name, expected_work: expected_work}
  end
end

require 'factory_bot'
require 'faker'

FactoryBot.define do
  factory :story do
    sequence(:name)
  end
end