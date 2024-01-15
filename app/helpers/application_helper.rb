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


  def show_meta_tags
    set_meta_tags(default_meta_tags)
    display_meta_tags
  end

  def default_meta_tags
    {
      site: 'いつものお弁当',
      title: 'いつものお弁当',
      reverse: true,
      charset: 'utf-8',
      description: '今ある材料でつくれるAIレシピとお弁当の記録カレンダーで、あなたのお弁当作りをサポートします',
      keywords: 'お弁当, レシピ, カレンダー',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'), # 配置するパスやファイル名によって変更すること
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('ogp.png') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end