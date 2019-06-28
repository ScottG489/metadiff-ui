const diffInputText = (state = "", action) => {
  switch (action.type) {
    case 'SET_DIFF_INPUT_TEXT':
      return action.text
    default:
      return state
  }
}

export default diffInputText