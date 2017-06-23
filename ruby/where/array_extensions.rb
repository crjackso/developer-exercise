class Array

  def where(criteria)
    subset = self
    
    criteria.each do |key, value|
      if value.is_a? Regexp
         subset.select! { |element| criteria[key] =~ element[key] }
      else
         subset.select! { |element| element[key] == criteria[key] }
      end
    end
    
    subset
  end

end