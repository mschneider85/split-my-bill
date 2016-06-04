class Array
  def merge_with(seperator)
    reject { |c| c.blank? }.join(seperator)
  end
end
