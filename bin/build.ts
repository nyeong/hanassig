import { compileAsciidoc } from '~/lib/asciidoc'
import * as repo from '~/lib/repository'
import {NoteFile} from '~/lib/repository'
import { rm, mkdir, cp, readdir } from 'node:fs/promises'
import { join } from 'node:path'
import * as R from 'remeda'


/**
 * 받은 디렉토리에서 adoc 파일 정보를 가져옵니다.
 */
export const getNotes = async (sourceDir: string) => {
  const files: NoteFile[] = R.pipe(
  await readdir(sourceDir),
  R.map(filename => new NoteFile(sourceDir, filename))
  )

  return files
}

async function main() {
  const DIST_DIR = 'dist'

  /**
   * source의 모든 내용을 `dest/source`에 복사합니다
   */
  const cpdir = async (source: string, dest?: string) => {
    const destDirName = dest ?? source
    const destDir = join(DIST_DIR, destDirName);
    await mkdir(destDir)
    return cp(`${source}`, destDir, {recursive: true})
  }

  await rm(DIST_DIR, { force: true, recursive: true})
  await mkdir(DIST_DIR)

  const notes = await getNotes('notes')

  R.forEach(notes, note => repo.addNote(note))
  R.forEach(repo.getAllNotes(), note => compileAsciidoc(note, DIST_DIR))

  await cpdir('figures')
  await cpdir('app/styles', 'styles')
  await cpdir('app/static', 'static')
}

main().then(r => console.log(r)).catch(err => console.error((err)))
