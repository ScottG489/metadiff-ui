import React from 'react';
import './App.css';
import {Provider} from 'react-redux'
import {createStore} from 'redux'
import reducers from './reducers'
import DiffInput from './components/DiffInput'
import DiffInfo from "./components/DiffInfo";

let initialState = {
  diffInputText: 'diff --git a/.gitignore b/.gitignore\n' +
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
    toFile: "",
    fromFile: "",
    fileStatus: "",
    addedFile: "",
    modifiedFile: "",
    removedFile: "",
    renamed: "",
    binary: "",
    mode: "",
    oldMode: "",
    checksumBefore: "",
    checksumAfter: "",
    copied: "",
    similarityIndex: "",
    disimilarityIndex: "",
    rawDiff: "",
  }
};

const store = createStore(reducers, initialState);

const App = () => (
  <Provider store={store}>
  <div>
    <DiffInput />
    <DiffInfo />
  </div>
  </Provider>
);

export default App;
