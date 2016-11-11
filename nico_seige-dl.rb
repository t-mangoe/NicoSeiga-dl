#!/usr/bin/env ruby
require "nokogiri"
require "open-uri"
require "net/https"

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

mail = "mailaddress" #write your mailaddress of niconico account
pass = "password" #write your password of niconico account
id = 2003928
sourceURL = "http://seiga.nicovideo.jp/image/source/"
seiga_url = "http://seiga.nicovideo.jp/seiga/"
cookie = login(mail,pass)

url = sourceURL + id.to_s

charset = nil
html = open(url,{"Cookie" => cookie}) do |f|
	charset = f.charset
	f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
illust = doc.css("div.illust_view_big")
img_src = illust.css("img").attr("src")
img_URL = "http://lohas.nicoseiga.jp" + img_src.to_s
title = doc.title
`wget -O #{title[0]}.jpg -nc #{img_URL}`
