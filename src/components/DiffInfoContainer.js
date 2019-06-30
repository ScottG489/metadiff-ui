import React from 'react';
import { useSelector } from 'react-redux';
import DiffInput from './DiffInput';
import DiffInfo from './DiffInfo';

const DiffInfoContainer = () => {
  const diffInfo = useSelector(state => state.diffInfo);
  return <DiffInfo diffInfo={diffInfo} />;
};

export default DiffInfoContainer;
