require 'asciidoctor'
require 'webrick'

task default: :build

task :build do
  Dir.glob('notes/**/*.adoc').each do |file|
    output_file = file.sub(/^notes/, 'dist').sub(/\.adoc$/, '.html')
    mkdir_p File.dirname(output_file)
    Asciidoctor.convert_file file, to_file: output_file, safe: :safe
  end
end

task :serve do
  Rake::Task[:build].invoke

  root = File.join(Dir.pwd, 'dist')
  server = WEBrick::HTTPServer.new Port: 8000, DocumentRoot: root

  trap 'INT' do
    server.shutdown
  end

  server.start
end