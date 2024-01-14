module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-green-100 border-green-400 text-green-700"
    when :notice  then "bg-blue-100 border-blue-400 text-blue-700"
    when :alert   then "bg-red-100 border-red-400 text-red-700"
    when :error   then "bg-yellow-100 border-yellow-400 text-yellow-700"
    else "bg-gray-100 border-gray-400 text-gray-700"
    end
  end

  def page_title(page_title= '')
    base_title = 'いつものお弁当'
    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end
