import {DiffInfoFormStore} from '../types';
import { SetDiffAction, DiffActionType } from '../actions';

export function setDiffReducer(
    state: DiffInfoFormStore = {} as DiffInfoFormStore,
    action: SetDiffAction<any>
    ): DiffInfoFormStore {

    switch (action.type) {
        case DiffActionType.SET_DIFF_INPUT_TEXT:
            return { ...state, diffInputText: action.payload };
        case DiffActionType.SET_DIFF_INFO:
            return {
                ...state, diffInfo: action.payload
            };
    }
    return state;
}