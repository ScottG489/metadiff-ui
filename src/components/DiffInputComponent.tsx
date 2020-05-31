import React, { FC } from 'react'
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
  return (
    <form
      onSubmit={async (event: React.FormEvent) => {
        await submitDiffInputText(event)
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

  async function submitDiffInputText (event: React.FormEvent) {
    event.preventDefault()
    await fetchDiffInfo(diffInput)
  }
}

export default DiffInputComponent
