class WordsController < ApplicationController
  #thanks! https://qiita.com/nishina555/items/4ffaf5cc57a384b66230
  skip_before_action :verify_authenticity_token

  def index
    logger.debug("miyakz index called")
    @words = Word.all
  end

  def register
    logger.debug("register #{params[:sentence_no]}")
    logger.debug("register #{params[:en]}")
  end

  def get

  end
end
