require 'bigdecimal'

words_hash = {}
line_words_array = []
all_words_array = []

probabilities_hash = {}
word_probabilities_array = []

File.open("blog.txt", 'r') do |file|
  file.each_line do |line|
    line_words_array = line.split(" ")
    line_words_array.each_with_index do |word, word_index|
      if words_hash[word] && word_index <= line_words_array.length
        words_hash[word] << line_words_array[word_index+1]
      elsif words_hash[word]
        words_hash[word] << ["\n"]
      else
        words_hash[word] = [line_words_array[word_index+1]]
      end
    end
  end
end

words_hash.each do |word, following_words|
  # file.write("#{word}\t#{following_words}\n")
  probabilities_hash[word] = []
  following_words.each do |following_word|
    float_holder = 1.to_f/following_words.length.to_f
    probabilities_hash[word] << [following_word, BigDecimal.new(float_holder, 4)]
  end
  all_words_array << word
end

file = File.open("word_breakdown.txt", 'w')

probabilities_hash.each do |word, probabilities|
  file.write("#{word};\t")
  probabilities.each do |probability|
    file.write("#{probability[0]}: #{probability[1].truncate(2).to_s('F')}, ")
  end
  file.write("\n")
end