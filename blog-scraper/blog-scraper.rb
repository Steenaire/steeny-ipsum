words_hash = {}
line_words_array = []

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

file = File.open("word_breakdown.txt", 'w')

words_hash.each do |word, following_words|
  file.write("#{word}\t#{following_words}\n")
end