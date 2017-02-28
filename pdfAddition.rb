#!/usr/bin/env ruby

require 'haml'
require 'money'
require 'pp'
#require 'wicked_pdf'

$sidius = []
$time = Time.new
$list = ARGV[0]

$list = $list.split(",").strip
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
  deathstar = $sidius[location]
  $sidius.delete_at(location)
  deathstar = deathstar[0..-2]
  deathstar << " " << "$" <<$list[0].to_s << "\n"
  $sidius.insert(location, deathstar)

  #give vader location to attack for contact
  location = $sidius.index{|s| s.include?("%p.p6.ft3")}
  vader = $sidius[location]
  $sidius.delete_at(location)
  vader = vader[0..-3]
  vader << " " << $list[1].to_s << ",\n"
  $sidius.insert(location, vader)

  #give vader location to attack for contact
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Chargeback Dollar Amount")} + 6
  people = $sidius[location]
  $sidius.delete_at(location)
  $list[2] = Money.new($list[2], 'USD')
  people = people[0..-9]
  people << ".p16.ft2" <<" $" << $list[2].to_s << "\n"
  $sidius.insert(location, people)

  #give totalamount to darth maul for insidius sceme
  location = $sidius.index{|s| s.include?("%p.p17.ft8 DEBITED TO YOUR ACCOUNT")} + 4
  darthmaul = $sidius[162]
  $sidius.delete_at(162)
  $list[3] = Money.new($list[3], 'USD')
  darthmaul = darthmaul[0..-6]
  darthmaul << ".ft2" <<" $" << $list[3].to_s << "\n"
  $sidius.insert(162, darthmaul)

  #give reason to count duku for being evil
  location = $sidius.index{|s| s.include?("%td.tr13.td10")} + 1
  countdooku = $sidius[location]
  $sidius.delete_at(location)
  countdooku = countdooku[0..-9]
  countdooku << ".ft2"<<" " << $list[4].to_s << "\n"
  $sidius.insert(location, countdooku)

  #return message for count duku being evil
  location = $sidius.index{|s| s.include?("%p.p4.ft2 Message:")} + 2
  palpatine = $sidius[location]
  $sidius.delete_at(location)
  palpatine = palpatine[0..-6]
  palpatine << ".ft2 " << $list[5].to_s << "\n"
  $sidius.insert(location, palpatine)

  #addition comments for republic control
  location = $sidius.index{|s| s.include?("%p.p4.ft2 Additional Comments:")} + 2
  republic = $sidius[location]
  $sidius.delete_at(location)
  republic = republic[0..-6]
  republic << ".ft2 " << $list[6].to_s << "\n"
  $sidius.insert(location, republic)

  #create date of original transaction
  location = $sidius.index{|s| s.include?("  %p.p14.ft2 Transaction Date:")} + 4
  orderDate = $sidius[location]
  $sidius.delete_at(location)
  orderDate = orderDate[0..-6]
  orderDate << ".ft2  " << $list[8].to_s << "\n"
  $sidius.insert(location, orderDate)

  #get number for card print
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Cardholder Account Number:")} + 2
  trans = $sidius[location]
  $sidius.delete_at(location)
  trans = trans[0..-6]
  trans << ".ft2 " << $list[9].to_s << "\n"
  $sidius.insert(location, trans)

  #Add original amount to transaction
  location = $sidius.index{|s| s.include?("%p.p14.ft2 OriginalTransaction Amount:")} + 2
  origin = $sidius[location]
  $sidius.delete_at(location)
  origin = origin[0..-6]
  origin << ".ft2 " << $list[10].to_s << "\n"
  $sidius.insert(location, origin)

  #Add reference number to transaction
  location = $sidius.index{|s| s.include?("%p.p14.ft2 Acquirer's Reference Number:")} + 2
  ref = $sidius[location]
  $sidius.delete_at(location)
  ref = ref[0..-6]
  ref << ".ft2 " << $list[11].to_s << "\n"
  $sidius.insert(location, ref)


  #Add pos entry mode to transaction
  location = $sidius.index{|s| s.include?("  %p.p14.ft2 Pos Entry Mode:")}
  pos = $sidius[location]
  $sidius.delete_at(location)
  pos = pos[0..-2]
  pos << " " << $list[12].to_s << "\n"
  $sidius.insert(location, pos)

  #Add tran code to transaction
  location = $sidius.index{|s| s.include?("%p.p19.ft2 Original Tran Code:")}
  tran = $sidius[location]
  $sidius.delete_at(location)
  tran = tran[0..-2]
  tran << " " << $list[13].to_s << "\n"
  $sidius.insert(location, tran)

  #Add record code to transaction
  location = $sidius.index{|s| s.include?("  %p.p14.ft2 Record Code:")}
  record = $sidius[location]
  $sidius.delete_at(location)
  record = record[0..-2]
  record << " " << $list[14].to_s << "\n"
  $sidius.insert(location, record)
end

File.foreach(__dir__+'/letter.html.haml').each do |line|
  $sidius.push line
end

deathstar

File.open("test.haml", "w+") do |f|
  $sidius.each do |element|
    f.puts(element)
  end
end
