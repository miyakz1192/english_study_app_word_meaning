require 'open-uri'

class WordsController < ApplicationController
  #thanks! https://qiita.com/nishina555/items/4ffaf5cc57a384b66230
  skip_before_action :verify_authenticity_token

  def index
    @words = Word.all
  end


  def register
    logger.debug("register #{params[:sentence_no]}")
    logger.debug("register #{params[:en]}")

    params[:en].split.each do |en|
      register_one(params[:sentence_no], en)
    end
  end

  def get
    logger.debug("get #{params[:sentence_no]}")
    unless already_sentence_registerd?(params[:sentence_no])
      not_found
      return
    end
    logger.debug("get start render")
    @words = Word.where(sentence_no: params[:sentence_no]).to_json
    logger.debug("get start render #{@words}")
    respond_to do |format|
      format.json { render json: @words}
    end
  end

protected
  def register_one(sentence_no, en)
    #thanks! http://otn.hatenablog.jp/entry/20090509/p1
    #thanks! https://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/index.html

    if already_registerd?(sentence_no, en)
      logger.debug("delete all word regarding #{sentence_no} because already_sentence_registerd")
      Word.where(sentence_no: sentence_no).destroy_all
    end

    slptime = Random.rand(10.0)
    logger.debug("register sleep time=#{slptime}")
    sleep slptime

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

    @word = Word.create(sentence_no: sentence_no, en: en, note: meaning.content, url: url)
  end

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
