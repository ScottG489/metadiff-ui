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
  diffInfos: [{
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
  }],
}

const App = () => {
  const [diffInfos, setDiffInfos] = useState(init.diffInfos)
  const [diffInputText, setDiffInput] = useState(init.diffInputText)

  const updateDiffInfo = (diffInfos: DiffInfo[]) => {
    setDiffInfos(diffInfos)
  }

  const updateDiffInput = (s: string) => {
    setDiffInput(s)
  }

  async function fetchDiffInfo (postData: string) {
    try {
      const response = await fetch(
        'https://api.conjob.io/job/run?image=scottg489/metadiff:latest',
        {
          method: 'POST',
          body: postData,
        },
      )
      const diffInfos: DiffInfo[] = await response.json()
      updateDiffInfo(diffInfos)
    } catch (e) {
      console.log(`Failure fetching diff info with diff input: ${e.message}`)
    }
  }

  const displayDiffInfos = (diffInfos: DiffInfo[]) => {
    return diffInfos.map(diffInfo => {
      return <div className="row">
        <div className="col">
          <DiffInfoComponent diffInfo={diffInfo} />
          <hr/>
        </div>
      </div>
    })
  }

  return (
    <div className="container">
      <div className="row justify-content-center">
        <div className="col-auto">
          <h1>Meta Diff</h1>
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
      {displayDiffInfos(diffInfos)}
    </div>
  )
}

export default App
