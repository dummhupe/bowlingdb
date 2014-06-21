class MergeCategories < ActiveRecord::Migration
  def up
    mergedCategory = Category.new(:name => "Hausliga")
    mergedCategory.save

    categories = []
    Category.find(:all).each do |c|
      if c.name[/^Hausliga /] then
        MatchDay.update_all("category_id = #{mergedCategory.id}", "category_id = #{c.id}")
	c.destroy
      end
    end
  end

  def down
  end
end
