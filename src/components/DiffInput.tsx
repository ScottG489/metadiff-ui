import React from 'react';
import {useDispatch, useSelector} from 'react-redux'
import {setDiffInfo, setDiffInputText} from '../actions'
import 'bootstrap'
import {DiffInfo, DiffInfoFormStore} from "../types";

let DiffInput = () => {
  const dispatch = useDispatch()
  const text = useSelector((state: DiffInfoFormStore) => state.diffInputText)
  let input: HTMLTextAreaElement

  return (
    <form onSubmit={
      async (event: React.FormEvent) =>
        dispatch(setDiffInfo(await submitDiffInputText(event, input)))
    }>
      <div className="form-group">
        <textarea
          className="form-control"
          rows={10}
          value={text}

          ref={(node: any) => {
            input = node
          }}

          onChange={() => dispatch(setDiffInputText(input.value))}
        />
      </div>
      <div className="form-group">
        <input className="form-control" type="submit" value="Submit"/>
      </div>
    </form>
  )
};

async function submitDiffInputText(event: React.FormEvent, input: HTMLTextAreaElement): Promise<DiffInfo> {
  event.preventDefault();
  let foo = await fetch('http://simple-ci.com/build?image=scottg489/diff-info:latest&pull=\n' +
      'false', {
    method: 'POST',
    body: input.value
  })
    .then(async response => {
      return response.json()
    })
    .catch(reason => console.log("Failure reason: " + reason));

  return foo;
}

export default DiffInput