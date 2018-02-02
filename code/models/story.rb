class Story
  attr_accessor :name, :development, :review, :qa

  def to_s
    "#{development}/#{review}/#{qa}: #{name}"
  end
end
