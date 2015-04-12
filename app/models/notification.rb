class Notification < Struct.new(:title, :body, :url)
  class Error < Notification
    def body
      "#{title}\n\n#{super.map{|t| "  #{t}\n"}.join}"
    end
  end
end
