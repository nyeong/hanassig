def replace_xrefs(filename)
  source = File.readlines(filename)

  replaced = source.map do |line|
    matched = line.scan(/<<([a-z0-9_-]*)#>>/)
    next line if matched.empty?
    matched.map do |file|
      first_line = File.open("notes/#{file[0]}.adoc", &:readline)
      title = first_line.match(/^= (.*)\n$/)
      raise "NoTitleFound: #{file}" unless title
      [file[0], title[1]]
    end.each do |pattern|
      slug, title = pattern
      line.gsub!("<<#{slug}#>>", "<<#{slug}#,#{title}>>")
    end
    line
  end

  File.write(filename, replaced.join())
end

if __FILE__ == $0
  ARGV.filter { |file| file.end_with?('.adoc') }.each do |file|
    replace_xrefs(file)
  end
end
