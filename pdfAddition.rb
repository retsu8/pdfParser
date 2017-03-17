#!/usr/bin/env ruby

require 'money'
require 'fuzzy_match'
require 'prawn'
require 'pdftk'
require 'combine_pdf'
require 'fileutils'
require 'date'

$creditcards =['discover','amex','mastercard','visa']
Money.use_i18n = false
$time = Time.new
$mid = ARGV[0]
$list = ARGV[1]

$list = $list.split(',')

$discover = "discover.pdf"
$amex = "Amex.pdf"
$mcvisa = "MCVisa.pdf"
$retrieval = "RetrievalRequestFulfillmentForm.pdf"
$prawnmask = "temp.pdf"

if $list.to_s.empty?
  puts "incorrect input nothing in argv to make into a pdf"
  exit
end
def buildUsecase
  $date = $time.strftime("%d-%m-%Y")
  $dollaramount = "$"+ Money.new($list[1], 'USD').to_s
  $name = $list[2]
  $address = $list[3]
  $city =$list[4]
  $state = $list[5]
  $zip = $list[6]
  $chargeamount = "$"+ Money.new($list[7], 'USD').to_s
  $totalamount = "$"+ Money.new($list[8], 'USD').to_s
  $reasoncode = $list[9]
  $message = $list[10]
  $addcomments = $list[11]
  $dcharg =  DateTime.parse($list[12])
  $transDate = $dcharg.strftime("%d-%m-%Y")
  $cardnumber = $list[13]
  $transamount = "$"+ Money.new($list[14], 'USD').to_s
  $ref = $list[15]
  $pos = $list[16]
  $trancode = $list[17]
  $reccode = $list[18]
end
def prawnbuild
  Prawn::Document.generate($prawnmask, :page_size => "LETTER", :page_layout => :portrait) do
    font "Courier" do
      draw_text $date, :at => [85,630]
      draw_text $dollaramount, :at =>[425,630]
      draw_text $name.capitalize+",", :at =>[50,590]
      draw_text $address.capitalize+",", :at =>[50,575]
      draw_text $city.capitalize+", "+$state+",", :at =>[50,560]
      draw_text $zip +",", :at =>[50,545]
      font_size 10
      w = 57
      bounding_box [400,260], :width => w, :height => 10 do
        #stroke_bounds
        text_box $chargeamount, :width => w, :align => :right
      end
      bounding_box [400,235], :width => w, :height => 10 do
        #stroke_bounds
        text_box $totalamount, :width => w, :align => :right
      end
      text_box $reasoncode, :at =>[140,193]
      text_box $message, :at =>[140,180]
      text_box $addcomments, :at =>[140,180]
      text_box $transDate, :at =>[170,125]
      text_box $cardnumber, :at =>[220,112]
      text_box $transamount, :at =>[220,100]
      text_box $ref, :at =>[225,86]
      text_box $pos, :at =>[162,73]
      text_box $trancode, :at =>[360,73]
      text_box $reccode, :at =>[148,61]
    end
  end
end

def merge(type)
  stamp = CombinePDF.load($prawnmask).pages[0]
  pdf = CombinePDF.load(type) # one way to combine, very fast.
  pdf.pages.each {|page| page << stamp}
  $month = Date::MONTHNAMES[$dcharg.month]
  FileUtils::mkdir_p "chargebackPDF/"+$mid+"/"+$dcharg.year.to_s+"/"+$month.to_s
  pdf.save "chargebackPDF/"+$mid+"/"+$dcharg.year.to_s+"/"+$month.to_s+"/card"+$cardnumber+"reference"+$ref+".pdf"
end
matcher = FuzzyMatch.new($creditcards)
matched = matcher.find($list[0])

case matched
when 'discover'
  buildUsecase
  prawnbuild
  merge($discover)
when 'amex'
  buildUsecase
  prawnbuild
  merge($amex)
when 'mastercard'
  buildUsecase
  prawnbuild
  merge($mcvisa)
when 'visa'
  buildUsecase
  prawnbuild
  merge($mcvisa)
else
  puts "no reconized input in first slot"
end
