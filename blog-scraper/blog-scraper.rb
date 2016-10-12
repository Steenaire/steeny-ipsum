require 'bigdecimal'

words_hash = {}
line_words_array = []
all_words_array = []

words_popularity_hash = {}

probabilities_hash = {}

randomizer_words_array = []

File.open("blog.txt", 'r') do |file|
  file.each_line do |line|
    line_words_array = line.split(" ")
    line_words_array.each_with_index do |word, word_index|
      if words_hash[word] && word_index <= line_words_array.length
        words_popularity_hash[word] += 1
        words_hash[word] << line_words_array[word_index+1]
      elsif words_hash[word]
        # words_hash[word] << ["\n"]
        words_popularity_hash[word] += 1
      else
        words_hash[word] = [line_words_array[word_index+1]]
        words_popularity_hash[word] = 1
      end
    end
  end
end

words_hash.each do |word, following_words|
  # file.write("#{word}\t#{following_words}\n")
  following_words.each do |following_word|
    float_holder = 1.to_f/following_words.length.to_f
    if probabilities_hash[word]
      if probabilities_hash[word][:"#{following_word}"]
        probabilities_hash[word][:"#{following_word}"] += 1
      else
        probabilities_hash[word][:"#{following_word}"] = 1
      end
    else
      probabilities_hash[word] = {"#{following_word}": 1}
    end
  end
  all_words_array << word
end

words_popularity_hash.each do |word, count|
  count.times do
    randomizer_words_array << word
  end
end

random_word = randomizer_words_array.sample

print "#{random_word} "
500.times do
  if probabilities_hash[random_word]
    probabilities_hash[random_word].each do |following_word, probability|
      probability.times do
        randomizer_words_array << following_word
      end
    end
  end
  random_word = randomizer_words_array.sample
  print "#{random_word} "
end

# Is it necessary to explicitly list all probabilities of 0????
###############################################################
# all_words_array.each do |compare_word|
#   probabilities_hash.each do |first_word, following_word|
#     unless probabilities_hash[first_word][:"#{compare_word}"]
#       probabilities_hash[first_word][:"#{compare_word}"] = BigDecimal.new(0)
#     end
#   end
# end

file = File.open("word_breakdown.txt", 'w')

probabilities_hash.each do |word, probabilities|
  file.write("#{word};\t")
  probabilities.each do |following_word, probability|
    file.write("#{following_word}: #{probability}, ")
  end
  file.write("\n")
end
