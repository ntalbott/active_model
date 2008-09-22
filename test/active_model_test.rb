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
  
  def test_initialize_attributes
    user = User.new(:name => "John Doe")
    assert_equal "John Doe", user.name
  end
  
  def test_attribute_names
    user = User.new
    assert_equal ["name"], user.attribute_names
  end
  
  def test_attributes
    user = User.new(:name => "John Doe")
    assert_equal({"name" => "John Doe"}, user.attributes)
  end
  
  def test_new_record?
    assert !User.new.new_record?
  end
end
