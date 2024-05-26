import Asciidoctor from 'asciidoctor'
import type { Inline, Html5Converter} from 'asciidoctor'
import * as repo from '~/lib/repository'

const asciidoctor = Asciidoctor()
const baseConverter: Html5Converter = new asciidoctor.Html5Converter()

const renderInlineAnchor = (node: Inline) => {
  const refid = node.getAttribute('refid')
  const path = node.getAttribute('path')
  if (path && refid) {
    const xrefDoc = repo.getNoteByFileName(path.replace('.html', '.adoc'))
    const href = node.getTarget().replace('.html', '/')
    const text = node.getText() ?? xrefDoc?.doc?.getTitle()
    return `<a href="/${href}">${text}</a>`
  }

  return baseConverter.convert(node)
}

export class Converter {
  // node: Document라고 퉁쳤는데, 실제로는 node 종류마다 다르니 주의
  convert (node: any, transform?: string, opts?: any): string {
    if (node.getNodeName() === 'inline_anchor') {
      return renderInlineAnchor(node)
    }
    if (node.getNodeName() === 'paragraph') {
      return `<p>${node.getContent()}</p>`
    }
    return baseConverter.convert(node, transform, opts)
  }
}
