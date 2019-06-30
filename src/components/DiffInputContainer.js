import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { setDiffInfo, setDiffInputText } from '../actions';
import DiffInput from './DiffInput';

const DiffInfoContainer = () => {
  const dispatch = useDispatch();
  const initialInput = useSelector(state => state.diffInputText);

  const submitHandler = async (e, input) => {
    const diffInfo = await submitDiffInputText(e, input);
    dispatch(setDiffInfo(diffInfo));
  };

  const changeHandler = inputValue => {
    dispatch(setDiffInputText(inputValue));
  };

  return (
    <DiffInput
      initialInput={initialInput}
      handleSubmit={submitHandler}
      handleChange={changeHandler}
    />
  );
};

const submitDiffInputText = async (event, input) => {
  event.preventDefault();
  let foo = await fetch(
    'https://diff-data.com/build?image=scottg489/diff-info:latest&pull=false',
    {
      method: 'POST',
      body: input,
    }
  )
    .then(response => {
      return response.json();
    })
    .catch(reason => console.log(reason));

  console.log(`Fetch results: ${JSON.stringify(foo)}`);
  return foo;
};

export default DiffInfoContainer;
