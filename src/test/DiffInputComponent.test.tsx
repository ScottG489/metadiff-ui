import React from 'react'
import { render, screen } from '@testing-library/react'
import '@testing-library/jest-dom'
import userEvent from '@testing-library/user-event'
import DiffInputComponent from '../components/DiffInputComponent'

test('renders text area with initial diff input text', async () => {
  const diffInputText: string = 'original text'

  const updateDiffInput = jest.fn()
  const fetchDiffInfo = jest.fn()

  render(<DiffInputComponent
    diffInput={diffInputText}
    updateDiffInput={updateDiffInput}
    fetchDiffInfo={fetchDiffInfo}
  />)

  const diffTextArea = screen.getByRole('textbox')

  expect(diffInputText).toBe('original text')
  expect(diffTextArea).toHaveValue(diffInputText)
})

test('calls updateDiffInput callback every time the diff input text changes', async () => {
  const diffInputText: string = 'original text'

  const updateDiffInput = jest.fn()
  const fetchDiffInfo = jest.fn()

  render(<DiffInputComponent
    diffInput={diffInputText}
    updateDiffInput={updateDiffInput}
    fetchDiffInfo={fetchDiffInfo}
  />)

  const diffTextArea = screen.getByRole('textbox')

  await userEvent.clear(diffTextArea)
  await userEvent.type(diffTextArea, 'lol')

  expect(updateDiffInput).toBeCalledTimes(4)
  expect(updateDiffInput).toHaveBeenNthCalledWith(1, '')
})

test('calls fetchDiffInfo callback when the form is submitted', async () => {
  const diffInputText: string = 'original text'

  const updateDiffInput = jest.fn()
  const fetchDiffInfo = jest.fn()

  render(<DiffInputComponent
    diffInput={diffInputText}
    updateDiffInput={updateDiffInput}
    fetchDiffInfo={fetchDiffInfo}
  />)

  const button = screen.getByRole('button')
  // TODO: Wrapping this in act here still doesn't fix warning. This is happening because we are updating
  // TODO:    the button text while we wait for the response.
  await userEvent.click(button)

  expect(fetchDiffInfo).toBeCalledTimes(1)
  expect(fetchDiffInfo).toBeCalledWith(diffInputText)
})
