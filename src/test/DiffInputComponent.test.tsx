import React from 'react'
import {render, fireEvent, waitFor, screen} from '@testing-library/react'
import '@testing-library/jest-dom'
import userEvent from '@testing-library/user-event'
import DiffInfoComponent from '../components/DiffInfoComponent'
import {DiffInfo} from '../types'
import DiffInputComponent from "../components/DiffInputComponent";

// TODO: The big problem here is that in the callback functions we are updating the
// TODO:    diffInputText but not via a 'set' method (since there isn't one) and
// TODO:    as a result the component isn't rerendering and it doesn't have the proper
// TODO:    state. For instance the diffInput value on the text area is never changed
// TODO:    since the component itself doesn't call it but rather it should be done via
// TODO:    the 'setter' which then triggers a rerender with it using the new value of diffInput
test('renders', async () => {
  let diffInputText: string =
      'diff --git a/.gitignore b/.gitignore\n' +
      'index feb3e1f..5835ba8 100644\n' +
      '--- a/.gitignore\n' +
      '+++ b/.gitignore\n' +
      '@@ -2,6 +2,7 @@\n' +
      ' build\n' +
      ' out\n' +
      '\n' +
      '+.idea/\n' +
      ' *.iml\n' +
      ' *.ipr\n' +
      ' *.iws'
  let postData = ''

  // const updateDiffInput = (s: string) => {
  //   diffInputText = s
  // }
  const updateDiffInput = jest.fn((s: string) => {
          diffInputText = s
        }
  )
  // const fetchDiffInfo = (s: string) => {
  //   postData = s
  // }
  const fetchDiffInfo = jest.fn()

  let ui = () => <DiffInputComponent
      diffInput={diffInputText}
      updateDiffInput={updateDiffInput}
      fetchDiffInfo={fetchDiffInfo}
  />;

  let foo = render(ui())

  let diffTextArea = screen.getByRole('textbox');

  // Good
  userEvent.clear(diffTextArea)
  await userEvent.type(diffTextArea, 'f')

  // At this point the local diffInput has been updated by the callback but the
  // component still needs to be rerendered
  foo.rerender(ui())
  let button = foo.getByRole('button');
  userEvent.click(button)
  // Needs to be called after click because click sets the postData internal
  // state but then needs a redraw so useEffect is ran and postData has a value.
  // And when use effect is ran again fetch is finally called
  foo.rerender(ui())

  expect(updateDiffInput).toHaveBeenNthCalledWith(1, '')
  expect(updateDiffInput).toHaveBeenNthCalledWith(2, 'f')
  expect(fetchDiffInfo).toHaveBeenNthCalledWith(1, 'f')
})
