# encoding: utf-8
class IndexController < ApplicationController
  def index
  end

  def show
    # TODO USE_FLAG判定を後々追加する
    @index = params[:index] || 0
    tag_id = params[:tag_id] || '0'
    @tag_name = (tag_id == '0') ? Settings.default_list_name : Tag.find(tag_id).tag
    order = params[:order] || Settings.default_order
    movie = Movie
    movie = movie.where(tag_id: tag_id) unless tag_id == '0'
    @items = movie.order(order).limit(Settings.limit_items_per_page).offset(@index)
    @lastquery = (@items.size >= Settings.limit_items_per_page) ? false : true
    # TODO tagsとitemsをmemcachedにぶっこむ
    # MEMCACHED tags -> tag_idをキー
    # MEMCACHED items = tag_idとorderとindexをキー
    render
  end

  def mylist

  end
  # TODO twitterでログイン機能

  # TODO ログインユーザがスターマーク機能

  # TODO ユーザのお気に入り画面(スター一覧/スター削除=DOMから消してお気に入りをdel_flg=1)

  def nicovideo
    @identifier = params[:key] ||  ""
    @h = params[:h] || 340
    @w = params[:w] || 440
    render layout: false
  end
end
