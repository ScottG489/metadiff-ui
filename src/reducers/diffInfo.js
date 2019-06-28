const diffInfo = (state = {}, action) => {
  switch (action.type) {
    case 'SET_DIFF_INFO':
      return action.diffInfo
    default:
      return state
  }
}

export default diffInfo