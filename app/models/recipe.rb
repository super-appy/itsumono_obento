class Recipe < ApplicationRecord
  attr_accessor :controller_name

  belongs_to :user, optional: true
  has_many :bookmarked_recipes

  # この順番じゃないとエラーになる
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  accepts_nested_attributes_for :recipe_tags, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_ingredients, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_steps, -> { order(number: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :recipe_steps, reject_if: :all_blank, allow_destroy: true

  enum time_required: { under_10: 0, minutes_10: 1, minutes_20: 2, over_20: 3 }
  enum taste: { japanese: 0, chinese: 1, western:2 }

  def self.ransackable_attributes(*)
    ["taste", "tag_ids", "time_required", "title", "created_at"]
  end

  def self.ransackable_associations(*)
    ["recipe_tags", "tags"]
  end

  def self.build_with_ingredients_and_steps
    recipe = new
    3.times do
      recipe.recipe_ingredients.build
      recipe.recipe_steps.build
    end
    recipe
  end

  def self.create_from_api(params, api_resp)
      api_resp_name = api_resp.match(/(?<=:).*/)[0]
    begin
      api_resp_ingredients = api_resp.match(/(?<=材料\(一人前\):)[\s\S]*(?=手順)/)[0]
      api_resp_steps = api_resp.match(/(?<=手順:\n)[\s\S]*/)[0]
      taste_tag_time = make_taste_tag_time(params[:taste], params[:tag_ids], params[:time_required])

      new(params.merge(
        api_resp: api_resp,
        title: api_resp_name.strip,
        api_ingredients: api_resp_ingredients.strip,
        api_steps: api_resp_steps.strip,
        taste_tag_time: taste_tag_time
      ))
    rescue
      # 材料や手順でエラーが出たら全てを手順に入れて登録する
      new(params.merge(
        api_resp: api_resp,
        title: api_resp_name.strip,
        api_steps: api_resp.match(/(?<=材料)[\s\S]*/)[0].strip,
        taste_tag_time: 'cannot_registered'
      ))
    end
  end

  # AIレシピ用
  def self.make_taste_tag_time(taste, tag_ids, time_required)
    formatted_tag_ids = tag_ids.reject(&:blank?).map { |id| id.to_s.rjust(2, '0') }
    str_tags = formatted_tag_ids.join('')
    "#{taste}_#{str_tags}_#{time_required}"
  end

  # 通常のレシピ用
  def make_taste_tag_time(tag_ids)
    formatted_tag_ids = tag_ids.map { |id| id.to_s.rjust(2, '0') }
    str_tags = formatted_tag_ids.join('')
    "#{taste}_#{str_tags}_#{time_required}"
  end

  scope :sorted_by_creation, -> { order(created_at: :desc) }

  validates :time_required, :taste, presence: true
  validates :title, :taste_tag_time, presence: true, unless: -> {controller_name == 'api/recipes'}
  validates :title, length: { maximum: 50 }
  validates :api_ingredients, :api_steps, length: { maximum: 500 }

  validate :at_least_2_recipe_ingredients, :at_most_8_recipe_ingreditends, unless: -> {controller_name == 'api/recipes'}
  validate :at_least_3_recipe_steps, :at_most_5_recipe_steps, unless: -> {controller_name == 'api/recipes'}

  validate :only_one_tag_per_category
  validate :at_least_one_tag

  private

  def only_one_tag_per_category
    category_count = tags.group_by { |tag| tag.category }.map { |category, tags| [category, tags.count] }.to_h
    category_count.each do |category, count|
      category = I18n.t("enums.tag.category.#{category}")
      errors.add(:base, "カテゴリ「#{category}」には一つのタグのみ選択してください") if count > 1
    end
  end

  def at_least_one_tag
    errors.add(:base, "少なくとも1つのタグを選択してください") if tags.empty?
  end

  def at_least_2_recipe_ingredients
    if recipe_ingredients.reject(&:marked_for_destruction?).count < 2
      errors.add(:base, "材料の登録は2つ以上にしてください")
    end
  end

  def at_most_8_recipe_ingreditends
    if recipe_ingredients.reject(&:marked_for_destruction?).count > 8
      errors.add(:base, "材料の登録は8つ以下にしてください")
    end
  end

  def at_least_3_recipe_steps
    if recipe_steps.reject(&:marked_for_destruction?).count < 3
      errors.add(:base, "調理手順の登録は3つ以上にしてください")
    end
  end

  def at_most_5_recipe_steps
    if recipe_steps.reject(&:marked_for_destruction?).count > 5
      errors.add(:base, "調理手順の登録は5つ以下にしてください")
    end
  end

end
