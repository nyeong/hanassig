require 'test/unit'

class MyTest < Test::Unit::TestCase
  
  def setup
    @notes = Dir['notes/**/*']
    @dirs = @notes.filter { |f| File.directory?(f) }
  end

  # a directory should have a markdown file as an index with same name in same path
  def test_directories_have_own_index
    @dirs.each do |dir|
      assert_not_nil @notes.find {|f| f == dir + ".md"}, "#{dir} does not have a index file"
    end
  end
end