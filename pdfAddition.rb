#!/usr/bin/env ruby

require 'haml'
require 'money'
require 'pp'
require 'fuzzy_match'
require 'prawn'
require 'pdftk'
#require 'wicked_pdf'

$creditcards =['discover','amex','mastercard','visa']
$sidius = []
$time = Time.new
$list = ARGV[0]

$discover = "discover.pdf"
$amex = "Amex.pdf"
$mcvisa = "MCVisa.pdf"
$retrieval = "RetrievalRequestFulfillmentForm.pdf"
$prawnmask = "temp.pdf"

if $list.to_s.empty?
  puts "incorrect input nothing in argv to make into a pdf"
  exit
else
  $list = $list.split(",")
  puts $list
end

class DEATHSTAR
  $date = $time.strftime("%d/%m/%Y")
  Prawn::Document.generate($prawnmask, :page_size => "LETTER", :page_layout => :portrait) do
    draw_text $date, :at => [75,650]
  end
end

class MERGE(type)
  pdf = CombinePDF.new
  pdf << CombinePDF.load(type) # one way to combine, very fast.
  pdf << CombinePDF.load($prawnmask)
  pdf.save @type+"combined.pdf"
end
matcher = FuzzyMatch.new($creditcards)
matched = matcher.find($list[0])

case matched
when 'discover'
  DEATHSTAR.new
  MERGE($discover)
when 'amex'
  DEATHSTAR.new
when 'mastercard'
  DEATHSTAR.new
when 'visa'
  DEATHSTAR.new
else
  puts "no reconized input in first slot"
end
