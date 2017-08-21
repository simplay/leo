require 'open-uri'
require 'nokogiri'


class Translation

  attr_reader :type
  def initialize(data, type)
    @data = data
    @type = type
  end

  def text
    @data.text
  end

  def noun?
    type == 'Substantive'
  end
end

search_word = ARGV[0]

base_url = "https://dict.leo.org/englisch-deutsch/"

response = open("#{base_url}#{search_word}") { |f| f.read }
html_doc = Nokogiri::HTML response
translation_html = html_doc.css('div#mainContent').css('table.tblf1').css('tr')

type = ''
translations = []
translation_html.each do |translation|
  if translation.parent.name == "thead"
    type = translation.text
  else
    translations << Translation.new(translation, type)
  end
end

translations.select(&:noun?).each do |t|
  puts t.text
end
