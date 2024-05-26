#!/usr/bin/env tsx

import { exec } from 'node:child_process'
import Watcher from 'watcher'
import { DIST_DIR } from '~/lib/env'

console.log('watcher runs')

const copyOnEvent = (_, path) => {

}

const noteWatcher = new Watcher('notes', { ignoreInitial: true })
noteWatcher.on('all', (_, path) => {
  console.log(path);
})

const staticWatcher = new Watcher('app/styles', { ignoreInitial: true })
staticWatcher.on('all', () => {
  exec(`cp -rf ./app/styles/* ${DIST_DIR}/styles/`)
})
