import {Action} from 'redux'
import {DiffInfo} from "../types";

export enum DiffActionType {
    SET_DIFF_INPUT_TEXT = 'SET_DIFF_INPUT_TEXT',
    SET_DIFF_INFO = 'SET_DIFF_INFO'
}

export interface SetDiffAction<T> extends Action<DiffActionType> {
    type: DiffActionType;
    payload: T;
}

export interface SetDiffInputText extends SetDiffAction<string> {
    type: DiffActionType.SET_DIFF_INPUT_TEXT;
    payload: string;
}

export interface SetDiffInfo extends SetDiffAction<DiffInfo> {
    type: DiffActionType.SET_DIFF_INFO;
    payload: DiffInfo;
}

export function setDiffInputText(text: string): SetDiffInputText {
    return {
        type: DiffActionType.SET_DIFF_INPUT_TEXT,
        payload: text
    }
}

export function setDiffInfo(diffInfo: DiffInfo): SetDiffInfo {
    return {
        type: DiffActionType.SET_DIFF_INFO,
        payload: diffInfo
    }
}
