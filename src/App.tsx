import React, { useState } from 'react'
import { DiffInfo, DiffInfoFormStore } from './types'
import DiffInputComponent from './components/DiffInputComponent'
import DiffInfoComponent from './components/DiffInfoComponent'

const init: DiffInfoFormStore = {
  diffInputText:
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
    ' *.iws',
  diffInfo: {
    toFile: '',
    fromFile: '',
    fileStatus: '',
    addedFile: '',
    modifiedFile: '',
    removedFile: '',
    renamed: '',
    binary: '',
    mode: '',
    oldMode: '',
    checksumBefore: '',
    checksumAfter: '',
    copied: '',
    similarityIndex: '',
    disimilarityIndex: '',
    rawDiff: '',
  },
}

const App = () => {
  const [diffInfo, setDiffInfo] = useState(init.diffInfo)
  const [diffInputText, setDiffInput] = useState(init.diffInputText)

  const updateDiffInfo = (s: DiffInfo) => {
    setDiffInfo(s)
  }

  const updateDiffInput = (s: string) => {
    setDiffInput(s)
  }

  function fetchDiffInfo (postData: string) {
    fetch(
      'http://simple-ci.com:8080/build?image=scottg489/diff-info:latest&pull=\n' +
      'false',
      {
        method: 'POST',
        body: postData,
      },
    )
      .then(async (response) => {
        const diffInfo: DiffInfo = await response.json()
        updateDiffInfo(diffInfo)
      })
      .catch((reason) => console.log('Failure reason: ' + reason))
  }

  return (
    <div className="container">
      <div className="row justify-content-center">
        <div className="col-auto">
          <h1>Diff Info</h1>
        </div>
      </div>
      <div className="row">
        <div className="col">
          <DiffInputComponent
            diffInput={diffInputText}
            updateDiffInput={updateDiffInput}
            fetchDiffInfo={fetchDiffInfo}
          />
        </div>
      </div>
      <div className="row">
        <div className="col">
          <DiffInfoComponent diffInfo={diffInfo} />
        </div>
      </div>
    </div>
  )
}

export default App
