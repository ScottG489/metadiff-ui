import React from 'react'
import {render, getByText, screen} from '@testing-library/react'
import '@testing-library/jest-dom'
import DiffInfoComponent from '../components/DiffInfoComponent'
import {DiffInfo} from '../types'

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
    rawDiff: 'raw diff value',
  }

  render(<DiffInfoComponent diffInfo={diffInfo}/>)

  expect(getCellNextSibling('To File:')).toHaveTextContent('to file value')
  expect(getCellNextSibling('From File:')).toHaveTextContent('from file value')
  expect(getCellNextSibling('File Status:')).toHaveTextContent('file status value')
  expect(getCellNextSibling('Is Added File:')).toHaveTextContent('is added file value')
  expect(getCellNextSibling('Is Modified File:')).toHaveTextContent('is modified file value')
  expect(getCellNextSibling('Is Removed File:')).toHaveTextContent('is removed file value')
  expect(getCellNextSibling('Is Renamed File:')).toHaveTextContent('is renamed file value')
  expect(getCellNextSibling('Is Binary File:')).toHaveTextContent('is binary file value')
  expect(getCellNextSibling('Mode:')).toHaveTextContent('mode value')
  expect(getCellNextSibling('Old Mode:')).toHaveTextContent('old mode value')
  expect(getCellNextSibling('Checksum Before:')).toHaveTextContent('checksum before value')
  expect(getCellNextSibling('Checksum After:')).toHaveTextContent('checksum after value')
  expect(getCellNextSibling('Is Copied File:')).toHaveTextContent('is copied value')
  expect(getCellNextSibling('Similarity Index:')).toHaveTextContent('similarity index value')
  expect(getCellNextSibling('Disimilarity Index:')).toHaveTextContent('disimilarity index value')
  expect(screen.getByRole('heading', {name: 'Raw Diff:'}).nextSibling).toHaveTextContent('raw diff value');
})

function getCellNextSibling(cellName: string) {
  return screen.getByRole('cell', {name: cellName}).nextSibling;
}
