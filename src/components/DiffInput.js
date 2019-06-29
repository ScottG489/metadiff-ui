import React from 'react';
import {useDispatch, useSelector} from 'react-redux'
import {setDiffInfo, setDiffInputText} from '../actions'
import 'bootstrap'

let DiffInput = () => {
  const dispatch = useDispatch()
  const text = useSelector(state => state.diffInputText)
  let input;

  return (
    <form onSubmit={
      async (event) =>
        dispatch(setDiffInfo(await submitDiffInputText(event, input)))
    }>
      <div className="form-group">
        <textarea
          className="form-control"
          rows="10"
          value={text}

          ref={node => {
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

let submitDiffInputText = async (event, input) => {
  event.preventDefault();
  console.log("'" + input.value + "'");
  let foo = await fetch('https://diff-data.com/build?image=scottg489/diff-info:latest&pull=false', {
    method: 'POST',
    body: input.value
  })
    .then(response => {
      return response.json()
    })
    .catch(reason => console.log(reason));

  console.log(foo)
  return foo;
};

export default DiffInput