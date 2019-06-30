import React from 'react';
import PropTypes from 'prop-types';

const DiffInfo = ({ diffInfo }) => {
  return (
    <div className="row">
      <div className="col">
        <table className="table table-sm table-striped">
          <tbody>
            <tr>
              <th>To file:</th>
              <th>{diffInfo.toFile}</th>
            </tr>
            <tr>
              <th>From file:</th>
              <th>{diffInfo.fromFile}</th>
            </tr>
            <tr>
              <th>File status:</th>
              <th>{diffInfo.fileStatus}</th>
            </tr>
            <tr>
              <th>Is Added File:</th>
              <th>{convertToString(diffInfo.addedFile)}</th>
            </tr>
            <tr>
              <th>Is Modified File:</th>
              <th>{convertToString(diffInfo.modifiedFile)}</th>
            </tr>
            <tr>
              <th>Is Removed File:</th>
              <th>{convertToString(diffInfo.removedFile)}</th>
            </tr>
            <tr>
              <th>Is Renamed file:</th>
              <th>{convertToString(diffInfo.renamed)}</th>
            </tr>
            <tr>
              <th>Is Binary File:</th>
              <th>{convertToString(diffInfo.binary)}</th>
            </tr>
            <tr>
              <th>Mode:</th>
              <th>{diffInfo.mode}</th>
            </tr>
            <tr>
              <th>Old Mode:</th>
              <th>{diffInfo.oldMode}</th>
            </tr>
            <tr>
              <th>Checksum Before:</th>
              <th>{diffInfo.checksumBefore}</th>
            </tr>
            <tr>
              <th>Checksum After:</th>
              <th>{diffInfo.checksumAfter}</th>
            </tr>
            <tr>
              <th>Is Copied File:</th>
              <th>{convertToString(diffInfo.copied)}</th>
            </tr>
            <tr>
              <th>Similarity Index:</th>
              <th>{diffInfo.similarityIndex}</th>
            </tr>
            <tr>
              <th>Disimilarity Index:</th>
              <th>{diffInfo.disimilarityIndex}</th>
            </tr>
          </tbody>
        </table>
      </div>
      <div className="col">
        <h5>Raw Diff:</h5>
        <textarea
          className="form-control"
          rows="18"
          value={diffInfo.rawDiff}
          readOnly
        />
      </div>
    </div>
  );
};

DiffInfo.propTypes = {
  diffInfo: PropTypes.object.isRequired,
};

const convertToString = obj => {
  if (obj !== null && obj !== undefined) return obj.toString();
};

export default DiffInfo;
