module ApplicationHelper
  # Helper method for making a float breaking block level element
  #
  # @example 
  #   <%= clear_break %>
  #   renders:
  #   <br clear='all' style='clear: both;'/>
  # 
  # @return [HTML Fragment] 
  # 
  # @api public
  def clear_break
    raw "<br clear='all' style='clear: both;'/>"
  end
end
