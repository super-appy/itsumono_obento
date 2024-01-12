module SelectListable
  extend ActiveSupport::Concern

  private

  def set_select_lists
    @all_tags =Tag.all
    @tags = @all_tags.group_by(&:category).transform_values do |tags|
      tags.map { |tag| [tag.name, tag.id] }
    end
  end
end
