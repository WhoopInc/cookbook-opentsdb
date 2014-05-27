module JavaPropertiesHelper
  def self.included(_)
    require 'java-properties'
  end

  def generate_properties(options)
    options = options.dup
    options.each do |k, v|
      next unless v.kind_of?(Array)
      options[k] = v.join(',')
    end
    JavaProperties.generate(options)
  end
end
