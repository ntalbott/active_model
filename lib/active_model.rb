class ActiveModel
  
  cattr_accessor :logger
  
  include Reloadable::Subclasses
  
  class << self

    def attribute_names
      read_inheritable_attribute(:attribute_names) || []
    end

    def instantiate
      invalid_method
    end
  
    def model_attr(*attribute_names)
      attribute_names.collect!{|a| a.to_s}
      write_inheritable_array(:attribute_names, attribute_names)
      attribute_names.each do |a|
        attr_accessor a
        alias_method "#{a}_before_type_cast", a
      end
    end
  
    def human_attribute_name(attribute_key_name)
      attribute_key_name.humanize
    end
    
    def base_class
      self
    end

  end
  
  def initialize(attributes={})
    self.attributes = attributes if attributes
  end
  
  def attribute_names
    self.class.attribute_names
  end
  
  def attributes=(attributes)
    return unless attributes
    attributes.stringify_keys!
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end
  
  def method_missing(method_id, *args, &block)
    method_name = method_id.to_s
    if md = /(\?)$/.match(method_name)
      query_attribute(md.pre_match)
    else
      super
    end
  end
  
  def save
    create_or_update
  end
  alias save! save
  
  def create_or_update; end
  
  def [](attribute)
    instance_variable_get("@#{attribute}")
  end
  
  def []=(attribute, value)
    instance_variable_set("@#{attribute}", value)
  end
  
  def query_attribute(attr_name)
    attribute = self[attr_name]
    if attribute.kind_of?(Fixnum) && attribute == 0
      false
    elsif attribute.kind_of?(String) && attribute == "0"
      false
    elsif attribute.kind_of?(String) && attribute.empty?
      false
    elsif attribute.nil?
      false
    elsif attribute == false
      false
    elsif attribute == "f"
      false
    elsif attribute == "false"
      false
    else
      true
    end
  end

  alias respond_to_without_attributes? respond_to?
  
  def self.invalid_method
    raise "Invalid method for ActiveModel"
  end
  def invalid_method; self.class.invalid_method; end
  
  alias create invalid_method
  alias update invalid_method
  alias destroy invalid_method
  alias update_attribute invalid_method
  
  def new_record?
    false
  end
  
  include ActiveRecord::Validations
  include ActiveRecord::Callbacks
  
end