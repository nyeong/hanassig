require 'asciidoctor'

module Hanassig

# 각 노트에 대한 메타 정보
class Note
  # 파일의 절대 경로
  attr_reader :absolute_path

  # slug는 `notes`를 루트로 삼았을 때의 상대경로
  # 예) `index.adoc`
  attr_reader :relative_path

  # `=`로 지정한 asciidoc title
  attr_reader :title

  # :keywords:로 지정한 문서의 키워드
  attr_reader :keywords

  # 외부 URL 링크
  attr_reader :links

  # 이미지
  attr_reader :images

  attr_reader :refs

  attr_reader :xrefs

  def initialize path
    @absolute_path = path
    doc = Asciidoctor.load_file @absolute_path, catalog_assets: true, safe: :unsafe
    @title = doc.title
    @keywords = doc.attributes['keywords'] ? doc.attributes['keywords'].split(', ') : []
    @links = doc.catalog[:links]
    @images = doc.catalog[:images]
  end

  def relative_path
      @absolute_path.slice((NOTES_DIR.length + 1)..)
  end

  # 렌더링 될 html 파일의 상대경로
  # 예) `index.html`, `some-slug/index.html`
  def dist_path
      path = relative_path.gsub('.adoc', '.html')
      return path if path.end_with?('index.html')
      path.gsub('.html', '/index.html')
  end

  module Repo
    @@notes = []
    @@slugmap = {}
    @@keywords = {}

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
      res = all.find do |note|
        args.map do |k, v|
          begin
            note.send(k) == v
          rescue NoMethodError
            false
          end
        end.all?
      end
      res || []
    end

    def keywords
        @@keywords
    end

    private
    def self.init(directory)
      return @@notes unless @@notes.empty?
      return unless FileTest.directory?(directory)
      dirs = [directory]
      notes = []
      while dir = dirs.pop
        Dir.new(dir).each_child do |child|
          child = File.join(dir, child)
          if FileTest.directory? child
            dirs << child
          elsif File.extname(child) == '.adoc'
            note = Note.new child
            @@notes << note
            @@slugmap[note.relative_path] = note
            note.keywords.each do |keyword|
                @@keywords[keyword] = [] unless @@keywords[keyword]
                @@keywords[keyword] << note
            end
          end
        end
      end
    end
    init NOTES_DIR
  end
  extend Repo
end
end
