require "uri"
module QuestionsHelper
  def render_with_hashtags(description)
    h(description).gsub(/[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/questions/hashtag/#{word.delete('#')}"}.html_safe
  end

  def render_with_hashtags_and_uri(description)
    description = h(description)
    URI.extract(description, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text = link_to url, url, target: '_blank'
      (description).gsub!(url, sub_text)
    end
    (description).gsub(/[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/questions/hashtag/#{word.delete('#')}"}.html_safe
  end
end
