import fs from 'fs'
import { join } from 'path'

const dataDir = join(process.cwd(), 'public/json/')

export function getDatasets() {
  return fs.readdirSync(dataDir)
}

export function getAllPosts() {
  const datasets = getDatasets();
  console.log(datasets)
  return datasets
}