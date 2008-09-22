require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class User < ActiveModel
  model_attr :name
  validates_presence_of :name
end

class ActiveModelTest < Test::Unit::TestCase
  def test_validates_presence_of_name
    user = User.new
    assert !user.valid?
    assert_equal "can't be blank", user.errors.on(:name)
  end
end
