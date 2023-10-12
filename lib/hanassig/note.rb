require 'asciidoctor'

module Hanassig
class Note
  # path is a absolute path for the note.
  attr_reader :path

  # slug는 `notes`를 루트로 삼았을 때의 상대경로
  # 예) `index.adoc`
  attr_reader :slug

  attr_reader :doc

  # Create a note instance with given path
  def initialize path
    @path = path
    @slug = path.slice((NOTES_DIR.length + 1)..)
    @doc = Asciidoctor.load_file path
  end

  def title = @doc.title
  def keywords
    return [] unless @doc.attributes['keywords']
    @doc.attributes['keywords'].split(", ")
  end

  module Repo
    @@notes = []
    @@slugmap = {}

    def all
      @@notes
    end

    def first = all.first

    # Finds a note by slug
    def find slug
      @@slugmap[slug]
    end

    # Finds a note by attributes
    # Use `find` when find by slug`
    def find_by(**args)
      res = all.find do |n|
        args.map do |k, v|
          begin
            n.send(k) == v
          rescue NoMethodError
            false
          end
        end.all?
      end
      res || []
    end

    private
    def self.init(directory)
      return @@notes unless @@notes.empty?
      return unless FileTest.directory?(directory)
      dirs = [directory]
      notes = []
      while dir = dirs.pop
        Dir.new(dir).each_child do |c|
          c = File.join(dir, c)
          if FileTest.directory? c
            dirs << c
          elsif File.extname(c) == '.adoc'
            n = Note.new c
            @@notes << n
            @@slugmap[n.slug] = n
          end
        end
      end
    end
    init NOTES_DIR
  end
  extend Repo
end
end
