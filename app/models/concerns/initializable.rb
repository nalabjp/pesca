module Initializable
  def new(klass)
    class_name(klass).constantize.new
  end

  def class_name(klass)
    "#{name.underscore}/#{klass.to_s.underscore}".classify
  end
end