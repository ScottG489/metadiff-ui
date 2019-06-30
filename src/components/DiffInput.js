import React, { useState } from 'react';
import PropTypes from 'prop-types';
import 'bootstrap';

let DiffInput = ({ initialInput, handleChange, handleSubmit }) => {
  const [input, setInput] = useState(initialInput);
  return (
    // eslint-disable-next-line no-restricted-globals
    <form onSubmit={event => handleSubmit(event, input)}>
      <div className="form-group">
        <textarea
          className="form-control"
          rows="10"
          value={input}
          onChange={event => {
            const inputValue = event.target.value;
            setInput(inputValue);
            handleChange(inputValue);
          }}
        />
      </div>
      <div className="form-group">
        <input className="form-control" type="submit" value="Submit" />
      </div>
    </form>
  );
};

DiffInput.propTypes = {
  initialInput: PropTypes.string.isRequired,
  handleChange: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

export default DiffInput;
