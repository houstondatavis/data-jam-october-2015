require 'csv'
require 'sad_panda' 
require 'smarter_csv'

# csv library is required to read the CSV file.
# Sad Panda is required for sentiment analysis.

csv = SmarterCSV.process("sales.csv")

# #Checking "dirty data", savyiness of real estate agents
agents = { :anti_text_agents => 0, :anti_disclosure_agents => 0, :smart_agents => 0, :no_countertop_agents => 0 }

csv.each do |row|
	countertops = row[:countertops].downcase
	remarks = (row[:remarks] + row[:realremarks]).downcase
	if countertops.match(/granite/) && remarks.match(/granite/)
		agents[:smart_agents] += 1
	elsif countertops.match(/granite/)
		agents[:anti_text_agents] += 1
	elsif remarks.match(/granite/)
		agents[:anti_disclosure_agents] += 1
	else
		agents[:no_countertop_agents] += 1
	end
end

p agents


# #Setting up two empty Hashes to keep track of data. Houses_Hash keep track of how many houses either have the
# #desired trait (yes) or do not (no). Houses_Total keeps track of the TOTAL VALUE of all houses that share
# #the trait or do not share the trait. I later on calcuate the average value of all houses using the value
# #from Houses_Hash.
houses_hash = {:yes => 0, :no => 0 }

houses_total = { :yes => 0, :no => 0 }

# # This code checks whether the realtor selected Granite in the drop down menu
csv.each do |row|
	word = row[:countertops].downcase
	if word.match(/granite/)
		houses_hash[:yes] += 1
		houses_total[:yes] += row[:salesprice]
	else
		houses_hash[:no] += 1
		houses_total[:no] += row[:salesprice]
	end
end

puts houses_hash

puts "The average price of an home with the trait is: "
puts houses_total[:yes]/houses_hash[:yes]

puts "The average price of a home without the trait is: "
puts houses_total[:no]/houses_hash[:no]

# Resetting the Hashes
houses_hash = {:yes => 0, :no => 0 }
houses_total = { :yes => 0, :no => 0 }

# # Term Searching:

# # This code checks whether the relator used the word "granite" in either the realtor remarks or the remarks
# # to the customer.
# (The regex code in line 53 can be used for other natural langauge processing terms,
# for example, this code can be modified to check for properties thare are 'as-is')
csv.each do |row|
	remarks = row[:remarks]
	relator_remarks = row[:realremarks]
	words = remarks+relator_remarks
	words = words.downcase
	if words.match(/granite/)
		houses_hash[:yes] += 1
		houses_total[:yes] += row[:salesprice]
	else
		houses_hash[:no] += 1
		houses_total[:no] += row[:salesprice]
	end
end

puts houses_hash

puts "The average price of an home with the trait is: "
puts houses_total[:yes]/houses_hash[:yes]

puts "The average price of a home without the trait is: "
puts houses_total[:no]/houses_hash[:no]

# Sentiment Analysis. The resulting outcome is dirty and not to be trusted, because
# it claims that the more negative a house is, the higher the average price.

sentiment_houses = { :negative => 0, :netural => 0, :positive => 0 }
sentiment_total_price = { :negative => 0, :netural => 0, :positive => 0 }

counter = 0
csv.each do |row|
	remarks = row[:remarks]
	relator_remarks = row[:realremarks]
	words = remarks+relator_remarks
	sentiment = SadPanda.polarity(words)
	if sentiment >= 7
		sentiment_houses[:positive] += 1
		sentiment_total_price[:positive] += row[:salesprice]
	elsif sentiment <= 4
		sentiment_houses[:negative] += 1
		sentiment_total_price[:negative] += row[:salesprice]
	else
		sentiment_houses[:netural] += 1
		sentiment_total_price[:netural] += row[:salesprice]
	end
	counter += 1
	puts "House #{counter} analyzed."
end
puts sentiment_houses

puts "The average price of an home that is positive is: "
puts sentiment_total_price[:positive]/sentiment_houses[:positive]

puts "The average price of a home that is netural is: "
puts sentiment_total_price[:netural]/sentiment_houses[:netural]

puts "The average price of a home that is negative is:"
puts sentiment_total_price[:negative]/sentiment_houses[:negative]