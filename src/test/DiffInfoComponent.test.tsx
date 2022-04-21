import React from 'react'
import { render, screen } from '@testing-library/react'
import '@testing-library/jest-dom'
import DiffInfoComponent from '../components/DiffInfoComponent'
import { DiffInfo } from '../types'

test('Displays appropriate values', async () => {
  const diffInfo: DiffInfo = {
    toFile: 'to file value',
    fromFile: 'from file value',
    fileStatus: 'file status value',
    addedFile: 'is added file value',
    modifiedFile: 'is modified file value',
    removedFile: 'is removed file value',
    renamed: 'is renamed file value',
    binary: 'is binary file value',
    mode: 'mode value',
    oldMode: 'old mode value',
    checksumBefore: 'checksum before value',
    checksumAfter: 'checksum after value',
    copied: 'is copied value',
    similarityIndex: 'similarity index value',
    disimilarityIndex: 'disimilarity index value',
    rawDiff: 'raw diff value'
  }

  render(<DiffInfoComponent diffInfo={diffInfo}/>)

  expect(screen.getByRole('row', { name: 'To File: to file value' }))
  expect(screen.getByRole('row', { name: 'From File: from file value' }))
  expect(screen.getByRole('row', { name: 'File Status: file status value' }))
  expect(screen.getByRole('row', { name: 'Is Added File: is added file value' }))
  expect(screen.getByRole('row', { name: 'Is Modified File: is modified file value' }))
  expect(screen.getByRole('row', { name: 'Is Removed File: is removed file value' }))
  expect(screen.getByRole('row', { name: 'Is Renamed File: is renamed file value' }))
  expect(screen.getByRole('row', { name: 'Is Binary File: is binary file value' }))
  expect(screen.getByRole('row', { name: 'Mode: mode value' }))
  expect(screen.getByRole('row', { name: 'Old Mode: old mode value' }))
  expect(screen.getByRole('row', { name: 'Checksum Before: checksum before value' }))
  expect(screen.getByRole('row', { name: 'Checksum After: checksum after value' }))
  expect(screen.getByRole('row', { name: 'Is Copied File: is copied value' }))
  expect(screen.getByRole('row', { name: 'Similarity Index: similarity index value' }))
  expect(screen.getByRole('row', { name: 'Disimilarity Index: disimilarity index value' }))
  expect(screen.getByRole('textbox')).toHaveTextContent('raw diff value')
})
