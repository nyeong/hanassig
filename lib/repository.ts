import * as path from 'node:path'
import Asciidoctor, { Document } from 'asciidoctor'

const asciidoctor = Asciidoctor()

export class Note {
  readonly noteFile: NoteFile
  readonly doc: Document

  constructor(noteFile: NoteFile) {
    this.noteFile = noteFile
    this.doc = asciidoctor.loadFile(noteFile.path)
  }
}

// 파일에 대한 정보만 갖고 있음
export class NoteFile {
  // 프로젝트 디렉토리에서의 상대경로
  readonly path: string

  // 확장자를 포함한 파일 이름
  readonly filename: string

  get filenameWithoutExtension () {
    return this.filename.replace('.adoc', '')
  }

  constructor(filepath: string, filename: string) {
    this.path = path.join(filepath, filename)
    this.filename = filename
  }
}

const notes : Note[] = []
export const indexedByPath: Record<string, Note> = {}
export const indexedByFileName: Record<string, Note> = {}

export const addNote= (noteFile: NoteFile) => {
  const note = new Note(noteFile)

  notes.push(note)
  indexedByPath[note.noteFile.path] = note
  indexedByFileName[note.noteFile.filename] = note
}

export const getNoteByPath = (path: string) =>
  indexedByPath[path]
export const getNoteByFileName = (filename: string) =>
  indexedByFileName[filename]
export const getAllNotes = () =>
  notes
