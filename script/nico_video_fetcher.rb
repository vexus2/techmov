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

class NicoVideoFetcher
  def start
    # 既にニコニコ動画経由で取得された動画の識別子(sm00000000)一覧を取得
    @nicovideo_identifiers = Movie.get_identifiers(Settings.site_nicovideo)

    # ニコニコ動画へログインを行う
    cookie                 = login(Settings.nicovideo_id, Settings.nicovideo_pw)
    tags                   = Tag.all

    # タグ一覧を正規表現形式で保持
    @tags_regex            = Regexp.union(tags.map { |v| v.tag })

    # DB上のタグのクエリを投げる
    tags.each { |v| request(cookie, v) }
  end

  private

  # ログインしてクッキー抽出
  def login(mail, pass)
    host = 'secure.nicovideo.jp'
    path = '/secure/login?site=niconico'
    body = "mail=#{mail}&password=#{pass}"

    https             = Net::HTTP.new(host, 443)
    https.use_ssl     = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response          = https.start { |https|
      https.post(path, body)
    }

    cookie = ''
    response['set-cookie'].split('; ').each do |st|
      if idx=st.index('user_session_')
        cookie = "user_session=#{st[idx..-1]}"
        break
      end
    end

    return cookie
  end

  private
  def request(cookie, tag)
    import_array = []
    # 予め設定されたページ分取得を行う
    Settings.max_paging_count.times do |page_num|
      BatchLogger.debug page_num
      host = 'ext.nicovideo.jp'
      # tagでの指定検索
      # キーワード検索にする場合はtagの箇所をsearchに変更する
      path = "/api/search/tag/#{tag.tag}?mode=watch&order=d&page=#{page_num + 1}&sort=n"

      response = Net::HTTP.new(host).start { |http|
        request           = Net::HTTP::Get.new(path)
        request['cookie'] = cookie
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
      Movie.import import_array

      # APIクエリ毎に指定時間のスリープを行う
      BatchLogger.debug 'do sleep'
      sleep Settings.retry_sleep_seconds
    end
    # 検索したタグ単位でのDB登録を行う
  end
end

fetcher = NicoVideoFetcher.new
fetcher.start