import React, {FC, useState} from 'react';
import 'bootstrap'
import {DiffInfo} from "../types";

interface DiffInputProps {
    diffInput: string
    refresh: (s: DiffInfo) => void
}

let DiffInputComponent: FC<DiffInputProps> = ({diffInput, refresh}) => {
    const [textArea, setTextArea] = useState(diffInput);

    return (
        <form onSubmit={
            async (event: React.FormEvent) => {
                let diffInfo = await submitDiffInputText(event, textArea);
                refresh(diffInfo)
            }
        }>
            <div className="form-group">
        <textarea
            className="form-control"
            rows={10}
            value={textArea}

            onChange={(event) => {
                setTextArea(event.target.value);
            }}
        />
            </div>
            <div className="form-group">
                <input className="form-control" type="submit" value="Submit"/>
            </div>
        </form>
    )
};

async function submitDiffInputText(event: React.FormEvent, input: string): Promise<DiffInfo> {
    event.preventDefault();
    return await fetch('http://simple-ci.com:8080/build?image=scottg489/diff-info:latest&pull=\n' +
        'false', {
        method: 'POST',
        body: input
    })
        .then(async response => {
            return response.json()
        })
        .catch(reason => console.log("Failure reason: " + reason));
}

export default DiffInputComponent