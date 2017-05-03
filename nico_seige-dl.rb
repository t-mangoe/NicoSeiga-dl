#!/usr/bin/env ruby

require "nokogiri"
require 'mechanize'

LOGIN = 'https://secure.nicovideo.jp/secure/login?site=niconico'
agent = Mechanize.new

mail = "mailaddress" #write your mailaddress of niconico account
pass = "password" #write your password of niconico account
agent.post(LOGIN, 'mail' => mail, 'password' => pass)

id = 961724
sourceURL = "http://seiga.nicovideo.jp/image/source/"
seiga_url = "http://seiga.nicovideo.jp/seiga/"

url = sourceURL + id.to_s
data = agent.get(url)

doc = Nokogiri::HTML.parse(data.body)
illust = doc.css("div.illust_view_big")
img_src = illust.css("img").attr("src")
img_URL = "http://lohas.nicoseiga.jp" + img_src.to_s
title = doc.title.split
p title
`wget -O #{title[0]}.jpg -nc #{img_URL}`
