module Pipedream::Dsl
  module Sns
    PROPERTIES = %w[
      DisplayName
      KmsMasterKeyId
      Subscription
      TopicName
    ]
    PROPERTIES.each do |prop|
      define_method(prop.underscore) do |v|
        @properties[prop.to_sym] = v
      end
    end
  end
end
