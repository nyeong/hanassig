module Hanassig
class Converter < (Asciidoctor::Converter.for 'html5')
    register_for 'html5'

    def convert_inline_anchor node
        case node.type
        when :xref
            puts node.attributes
            super node
        else
            super node
        end
    end
end
end
