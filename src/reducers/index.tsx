import {SetDiff} from '../actions';
import {DiffInfoFormStore} from '../types';
import {SET_DIFF_INFO, SET_DIFF_INPUT_TEXT} from '../constants';

export function setDiffReducer(state: DiffInfoFormStore = {} as DiffInfoFormStore, action: SetDiff): DiffInfoFormStore {
    switch (action.type) {
        case SET_DIFF_INPUT_TEXT:
            return { ...state, diffInputText: action.text };
        case SET_DIFF_INFO:
            return {
                ...state, diffInfo: {
                    toFile: action.toFile,
                    fromFile: action.fromFile,
                    fileStatus: action.fileStatus,
                    addedFile: action.addedFile,
                    modifiedFile: action.modifiedFile,
                    removedFile: action.removedFile,
                    renamed: action.renamed,
                    binary: action.binary,
                    mode: action.mode,
                    oldMode: action.oldMode,
                    checksumBefore: action.checksumBefore,
                    checksumAfter: action.checksumAfter,
                    copied: action.copied,
                    similarityIndex: action.similarityIndex,
                    disimilarityIndex: action.disimilarityIndex,
                    rawDiff: action.rawDiff
                }
            };
    }
    return state;
}