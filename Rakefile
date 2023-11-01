require_relative 'lib/hanassig'

namespace :build do
  task :html do
    Hanassig::Note.all.each do |note|
        Hanassig.convert note
   end
  end

  desc "Generate keywords.adoc file"
  task :keywords do
    buff = ""
    buff << "= 키워드\n"
    buff << ":description: 키워드 일람\n"
    buff << "\n"
    buff << "Generated at #{Time.now}\n"
    buff << "\n"
    Hanassig::Note.keywords.keys.sort!.each do |k|
      v = Hanassig::Note.keywords[k].sort! {|a, b| a.title <=> b.title }
      buff << "== #{k.sub('-', ' ').capitalize}\n\n"
      v.each do |note|
        buff << "- <<#{note.relative_path}#,#{note.title}>>\n"
      end
      buff << "\n\n"
    end
    File.open('notes/keywords.adoc', 'w') do |f|
      f.write buff.rstrip + "\n"
    end
  end
end
