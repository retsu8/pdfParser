#!/usr/bin/env ruby

require 'haml'
require 'money'
require 'pp'
require 'wicked_pdf'


$sidius = []
$time = Time.new
$list = ARGV[0]

$list = $list.split(",")
puts $list

def deathstar
  #assign pieces of the galaxy to stormtropper to add data
  stormtrooper = $sidius[114]
  $sidius.delete_at(114)
  stormtrooper = stormtrooper[0..-2]
  stormtrooper << ": "<< $time.strftime("%Y/%m/%d") << "\n"
  $sidius.insert(114, stormtrooper)

  #create allotment for deathstar to build
  Money.use_i18n = false
  location = $sidius.index{|s| s.include?("%p.p5.ft3 Dollar Amount:")}
  $list[0] = Money.new($list[0], 'USD')
  deathstar = $sidius[location].strip
  $sidius.delete_at(location)
  deathstar << " " << "$" <<$list[0].to_s << "\n"
  $sidius.insert(location, deathstar)

  #give vader location to attack for contact
  location = $sidius.index{|s| s.include?("%p.p6.ft3")}
  vader = $sidius[location].strip
  $sidius.delete_at(location)
  vader = vader[0..-2]
  vader << " " << $list[1].to_s << ",\n"
  $sidius.insert(location, vader)

  #give vader location to attack for contact
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Chargeback Dollar Amount")} + 6
  people = $sidius[location].strip
  $sidius.delete_at(location)
  $list[2] = Money.new($list[2], 'USD')
  people << " $" << $list[2].to_s << "\n"
  $sidius.insert(location, people)

  #give totalamount to darth maul for insidius sceme
  darthmaul = $sidius[162].strip
  $sidius.delete_at(162)
  $list[3] = Money.new($list[3], 'USD')
  darthmaul << "  $" << $list[3].to_s << "\n"
  $sidius.insert(162, darthmaul)

  #give reason to count duku for being evil
  countdooku = $sidius[182].strip
  $sidius.delete(182)
  countdooku << " " << $list[4].to_s << "\n"
  $sidius.insert(182, countdooku)

  #return message for count duku being evil
  location = $sidius.index{|s| s.include?("%p.p4.ft2 Message:")} + 2
  palpatine = $sidius[location].strip
  $sidius.delete(location)
  palpatine << " " << $list[5].to_s << "\n"
  $sidius.insert(location, palpatine)

  #addition comments for republic control
  republic = $sidius[225].strip
  $sidius.delete(225)
  republic << " " << $list[6].to_s << "\n"
  $sidius.insert(225, republic)

  #create date of original transaction
  location = $sidius.index{|s| s.include?("  %p.p14.ft2 Transaction Date:")} + 2
  orderDate = $sidius[location].strip
  $sidius.delete_at(location)
  orderDate = orderDate[0..-3]
  orderDate << " " << $list[8].to_s << "\n"
  $sidius.insert(location, orderDate)

  #get number for card print
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Cardholder Account Number:")} + 2
  trans = $sidius[location].strip
  $sidius.delete_at(location)
  trans << " " << $list[9].to_s << "\n"
  $sidius.insert(location, trans)

  #Add original amount to transaction
  location = $sidius.index{|s| s.include?("%p.p14.ft2 OriginalTransaction Amount:")} + 2
  origin = $sidius[location].strip
  $sidius.delete_at(location)
  origin << " " << $list[10].to_s << "\n"
  $sidius.insert(location, origin)

  #Add reference number to transaction
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Acquirer's Reference Number:")} + 2
  origin = $sidius[location].strip
  $sidius.delete_at(location)
  origin << " " << $list[11].to_s << "\n"
  $sidius.insert(location, origin)


  #Add pos entry mode to transaction
  location = $sidius.index{|s| s.include?("  %p.p14.ft2 Pos Entry Mode:")}
  pos = $sidius[location].strip
  $sidius.delete_at(location)
  pos << " " << $list[12].to_s << "\n"
  $sidius.insert(location, origin)

  #Add pos entry mode to transaction
  location = $sidius.index{|s| s.include?("%p.p19.ft2 Original Tran Code:")}
  pos = $sidius[location].strip
  $sidius.delete_at(location)
  pos << " " << $list[13].to_s << "\n"
  $sidius.insert(location, origin)
end

File.foreach('letter.html.haml').each do |line|
  $sidius.push line
end

deathstar

File.open("test.haml", "w+") do |f|
  $sidius.each do |element|
    #engine = Haml::Engine.new(element.strip)
    #output =engine.render
    f.puts(element)
  end
end
