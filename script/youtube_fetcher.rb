#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

if RUBY_VERSION < '1.9'
  require 'rubygems'
end
require File.expand_path('../../config/boot', __FILE__)
require 'json'
require 'mechanize'
require 'cgi'
require 'rexml/document'
require 'movie'
require 'tag'

class YoutubeFetcher
  def start
    # 既にYoutube経由で取得された動画の識別子一覧を取得
    @youtube_identifiers = Movie.get_identifiers(Settings.site_youtube)

    tags                   = Tag.all
    # タグ一覧を正規表現形式で保持
    @tags_regex            = Regexp.union(tags.map { |v| v.tag })

    # DB上のタグのクエリを投げる
    tags.each { |v| request(v) }
  end

  private
  def request(tag)
    import_array = []
    index = 1
    # 予め設定されたページ分取得を行う
    Settings.max_paging_count.times do |page_num|
      p index
      host = 'gdata.youtube.com'
      # tagでの指定検索
      # キーワード検索にする場合はtagの箇所をsearchに変更する
      path = "/feeds/api/videos?q=#{tag.tag}&orderby=published&start-index=#{index}&max-results=1&v=2&alt=json&safeSearch=strict&restriction=JP"
      index = index + 50

      response = Net::HTTP.new(host).start { |http|
        request           = Net::HTTP::Get.new(path)
        http.request(request)
      }

      begin
        parsed = JSON.parse(response.body)
      rescue
        # 連続でクエリを投げすぎた場合、エラーが返されるので
        # ログに出力し一定時間スリープさせる
        BatchLogger.error('Request Failed. response.body = ' + response.body)
        sleep Settings.retry_sleep_seconds
        next
      end


      p parsed["feed"]["entry"]
      p parsed["feed"]
      exit

      return if parsed["list"].nil?

      # 2012-10-08現在、以下の項目が取得可能
      # id(sm0000000)
      # thumbnail_url
      # length
      # view_counter（再生数）
      # num_res（コメント数）
      # mylist_counter（マイリスト数）
      parsed["list"].each do |v|
        # 既に該当動画を登録している場合は登録を行わない
        next if @nicovideo_identifiers.include?(v["id"])
        # 動画のタイトルに、タグに登録されている文言が含まれない場合は登録を行わない
        next unless v["title"] =~ @tags_regex
        movie                 = Movie.new
        movie.identifier      = v["id"]
        movie.thumbnail_url   = v["thumbnail_url"]
        movie.length          = v["length"]
        movie.title           = v["title"]
        movie.view_counter    = v["view_counter"]
        movie.site            = Settings.site_nicovideo
        movie.tag_id          = tag.id
        movie.comment_counter = v["num_res"]
        movie.mylist_counter  = v["mylist_counter"]
        import_array << movie
        BatchLogger.debug v["title"]
      end

      # APIクエリ毎に指定時間のスリープを行う
      sleep Settings.retry_sleep_seconds
    end
    # 検索したタグ単位でのDB登録を行う
    Movie.import import_array
  end
end

fetcher = YoutubeFetcher.new
fetcher.start