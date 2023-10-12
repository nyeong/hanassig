require_relative 'lib/hanassig'

namespace :generate do
  desc "Generate keywords.adoc file"
  task :keywords do
    kmap = {}
    Hanassig::Note.all.each do |n|
      n.keywords.each do |k|
        kmap[k] = [] unless kmap[k]
        kmap[k] << n
      end
    end

    buff = ""
    buff << "= 키워드\n"
    buff << ":description: 키워드 일람\n"
    buff << "\n"
    buff << "Generated at #{Time.now}\n"
    buff << "\n"
    kmap.keys.sort!.each do |k|
      v = kmap[k].sort! {|a, b| a.title <=> b.title }
      buff << "== #{k.sub('-', ' ').capitalize}\n\n"
      v.each do |note|
        buff << "- <<#{note.slug}#,#{note.title}>>\n"
      end
      buff << "\n\n"
    end
    File.open('notes/keywords.adoc', 'w') do |f|
      f.write buff
    end
  end
end
