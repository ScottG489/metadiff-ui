import React, {FC, useState} from 'react'
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
  const baseSubmitButtonText = 'Yeet'
  const [submitButtonText, setSubmitButtonText] = useState(baseSubmitButtonText)

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
        <button className="form-control btn-outline-primary">{submitButtonText}</button>
      </div>
    </form>
  )

  async function submitDiffInputText (event: React.FormEvent) {
    event.preventDefault()
    setSubmitButtonText('Yeeting...')
    await fetchDiffInfo(diffInput)
    setSubmitButtonText(baseSubmitButtonText)
  }
}

export default DiffInputComponent
