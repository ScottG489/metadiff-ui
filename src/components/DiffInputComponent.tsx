import React, { FC, useEffect, useState } from 'react'
import 'bootstrap'

interface DiffInputProps {
  diffInput: string
  fetchDiffInfo: (postData: string) => void
}

const DiffInputComponent: FC<DiffInputProps> = ({
  diffInput,
  fetchDiffInfo,
}: DiffInputProps) => {
  const [textArea, setTextArea] = useState(diffInput)
  const [postData, setPostData] = useState('')

  useEffect(doUseEffect, [postData])

  return (
    <form
      onSubmit={async (event: React.FormEvent) => {
        await submitDiffInputText(event, textArea)
      }}
    >
      <div className="form-group">
        <textarea
          className="form-control"
          rows={10}
          value={textArea}
          onChange={(event) => {
            setTextArea(event.target.value)
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
