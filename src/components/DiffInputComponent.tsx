import React, { FC, useEffect, useState } from 'react'
import 'bootstrap'

interface DiffInputProps {
  diffInput: string
  updateDiffInput: (s: string) => void
  fetchDiffInfo: (postData: string) => void
}

const DiffInputComponent: FC<DiffInputProps> = ({
  diffInput,
  updateDiffInput,
  fetchDiffInfo,
}: DiffInputProps) => {
  const [postData, setPostData] = useState('')

  useEffect(doUseEffect, [postData])

  return (
    <form
      onSubmit={async (event: React.FormEvent) => {
        await submitDiffInputText(event, diffInput)
      }}
    >
      <div className="form-group">
        <textarea
          className="form-control"
          rows={10}
          value={diffInput}
          onChange={(event) => {
            updateDiffInput(event.target.value)
          }}
        />
      </div>
      <div className="form-group">
        <button className="form-control btn-outline-primary">YEET</button>
      </div>
    </form>
  )

  function doUseEffect () {
    if (postData) {
      fetchDiffInfo(postData)
    }
  }

  function submitDiffInputText (
    event: React.FormEvent,
    input: string,
  ) {
    event.preventDefault()
    setPostData(input)
  }
}

export default DiffInputComponent
