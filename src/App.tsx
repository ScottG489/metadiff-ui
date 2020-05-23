import React, {useState} from 'react';
import {DiffInfo, DiffInfoFormStore} from './types'
import DiffInputComponent from './components/DiffInputComponent'
import DiffInfoComponent from "./components/DiffInfoComponent";

const init: DiffInfoFormStore = {
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
        rawDiff: ""
    }
};

const App = () => {
    const [state, setState] = useState(init);

    const refresh = (s: DiffInfo) => {
        setState({diffInputText: state.diffInputText, diffInfo: s});
    };

    return (
        <div className="container">
            <div className="row justify-content-center">
                <div className="col-auto">
                    <h1>Diff Info</h1>
                </div>
            </div>
            <div className="row">
                <div className="col">
                    <DiffInputComponent diffInput={state.diffInputText} refresh={refresh}/>
                </div>
            </div>
            <div className="row">
                <div className="col">
                    <DiffInfoComponent diffInfo={state.diffInfo}/>
                </div>
            </div>
        </div>
    )
};

export default App;
