module Codepipe::Dsl
  module Sns
    PROPERTIES = %w[
      display_name
      kms_master_key_id
      subscription
      topic_name
    ]
    PROPERTIES.each do |prop|
      define_method(prop) do |v|
        @properties[prop.to_sym] = v
      end
    end
  end
end
