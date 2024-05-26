import Asciidoctor from "asciidoctor";
import { Converter } from "~/lib/asciidoc/converter";
import { writeFile, readdir, mkdir } from 'node:fs/promises'
import { readFileSync } from 'node:fs'
import { join } from "node:path";
import { TEMPLATE_DIR } from "~/lib/env";
import { Note} from "~/lib/repository";
import * as ejs from 'ejs'

const asciidoctor = Asciidoctor()
asciidoctor.ConverterFactory.register(new Converter(), ['html5'])
const template = String(readFileSync(join(TEMPLATE_DIR, 'note.html.ejs')))


/**
 * dist 밑에 index.html을 저장하기 위한 서브 디렉토리를 만듭니다.
 * `dirname` 이름이 `index`일 경우 추가로 만들지 않습니다.
 */
const createDistDir = async (distRootDir: string, dirname: string) => {
  if (dirname === 'index') {
    return distRootDir
  }

  const distDir = join(distRootDir, dirname)
  await mkdir(distDir)
  return distDir
}

/**
 * file을 받아 `distRootDir/filename/index.html`을 생성합니다
 */
export const compileAsciidoc = async (note: Note, distRootDir: string) => {
  const content = note.doc.convert()
  const compiled = ejs.render(template, {
    title: note.doc.getTitle(),
    page: {
      title: '',
      description: '',
      keywords: '',
    },
    content,
  })
  const distDir = await createDistDir(distRootDir, note.noteFile.filenameWithoutExtension)
  const distPath = join(distDir, 'index.html')

  await writeFile(distPath, compiled, {encoding: 'utf8', flag: 'w'})

  return compiled
}
