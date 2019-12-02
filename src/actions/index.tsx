import * as constants from '../constants';
import {DiffInfo} from "../types";

export interface SetDiffInputText {
    type: constants.SET_DIFF_INPUT_TEXT;
    text: string;
}

export interface SetDiffInfo {
    type: constants.SET_DIFF_INFO;
    toFile: string;
    fromFile: string;
    fileStatus: string;
    addedFile: string;
    modifiedFile: string;
    removedFile: string;
    renamed: string;
    binary: string;
    mode: string;
    oldMode: string;
    checksumBefore: string;
    checksumAfter: string;
    copied: string;
    similarityIndex: string;
    disimilarityIndex: string;
    rawDiff: string;
}

// TODO: Weird?
export type SetDiff = SetDiffInputText | SetDiffInfo;

export function setDiffInputText(text: string): SetDiffInputText {
    return {
        type: constants.SET_DIFF_INPUT_TEXT,
        text: text
    }
}

export function setDiffInfo(diffInfo: DiffInfo): SetDiffInfo {
    return {
        type: constants.SET_DIFF_INFO,
        toFile: diffInfo.toFile,
        fromFile: diffInfo.fromFile,
        fileStatus: diffInfo.fileStatus,
        addedFile: diffInfo.addedFile,
        modifiedFile: diffInfo.modifiedFile,
        removedFile: diffInfo.removedFile,
        renamed: diffInfo.renamed,
        binary: diffInfo.binary,
        mode: diffInfo.mode,
        oldMode: diffInfo.oldMode,
        checksumBefore: diffInfo.checksumBefore,
        checksumAfter: diffInfo.checksumAfter,
        copied: diffInfo.copied,
        similarityIndex: diffInfo.similarityIndex,
        disimilarityIndex: diffInfo.disimilarityIndex,
        rawDiff: diffInfo.rawDiff
    }
}
