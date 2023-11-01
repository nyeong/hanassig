module Hanassig
  NOTES_DIR = File.join(Dir.getwd, 'notes')

  def self.convert note
    Asciidoctor.convert_file note.absolute_path,
        doctype: :html5,
        safe: :unsafe,
        to_file: 'dist/' + note.dist_path,
        mkdirs: true,
        attributes: {
            'toc' => 'right',
            'imagesdir' => './assets',
        }
  end
end

require_relative 'hanassig/note'
