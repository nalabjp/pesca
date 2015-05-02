class Notification < Struct.new(:title, :body, :url)
  def body
    Nokogiri::HTML(super).text
  end

  class Error < Struct.new(:title, :body)
    def body
      "#{title}\n\n#{super.map{|t| "  #{t}\n"}.join}"
    end
  end
end
