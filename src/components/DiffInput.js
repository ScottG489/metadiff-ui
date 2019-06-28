import React from 'react';
import {useDispatch, useSelector} from 'react-redux'
import {setDiffInfo, setDiffInputText} from '../actions'

let DiffInput = () => {
  const dispatch = useDispatch()
  const text = useSelector(state => state.diffInputText)
  let input;

  return (
    <div className="diff-info">
      <form className="text" onSubmit={
        async (event) =>
          dispatch(setDiffInfo(await submitDiffInputText(event, input)))
      }>
        <textarea
          value={text}

          ref={node => {
            input = node
          }}

          onChange={() => dispatch(setDiffInputText(input.value))}
        />
        <input type="submit" value="Submit"/>
      </form>
    </div>
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