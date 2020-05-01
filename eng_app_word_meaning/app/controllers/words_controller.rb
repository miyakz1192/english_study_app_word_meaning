require 'open-uri'

class WordsController < ApplicationController
  #thanks! https://qiita.com/nishina555/items/4ffaf5cc57a384b66230
  skip_before_action :verify_authenticity_token

  def index
    @words = Word.all
  end

  def register
    #thanks! http://otn.hatenablog.jp/entry/20090509/p1
    #thanks! https://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/index.html
    logger.debug("register #{params[:sentence_no]}")
    logger.debug("register #{params[:en]}")

    slptime = Random.rand(10.0)
    logger.debug("register sleep time=#{slptime}")
    sleep slptime

    sentence_no = params[:sentence_no]
    en = params[:en]

    url = "https://ejje.weblio.jp/content/#{en}"
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)
    meaning = doc.xpath("//td").detect{|td| td["class"] == "content-explanation ej"}
    unless meaning
      not_found
      return
    end
    return if already_registerd?(sentence_no, en)

    Word.create(sentence_no: sentence_no, en: en, note: meaning.content, url: url)
  end

  def get
    logger.debug("get #{params[:sentence_no]}")
    unless already_sentence_registerd?(params[:sentence_no])
      not_found
      return
    end
    @words = Word.where(sentence_no: params[:sentence_no]).to_json
    render status:200
  end

protected

  def already_sentence_registerd?(sentence_no)
    return true if Word.find_by_sentence_no(sentence_no) != nil
    return false
  end

  def already_registerd?(sentence_no, en)
    return true if Word.where(sentence_no: sentence_no, en:en).size >= 1
    return false
  end 

  def not_found
    render status: 404
  end
end
