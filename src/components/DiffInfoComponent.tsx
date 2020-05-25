import React, { FC } from 'react'
import { DiffInfo } from '../types'

export interface DiffInfoProps {
  diffInfo: DiffInfo;
}

const DiffInfoComponent: FC<DiffInfoProps> = ({ diffInfo }: DiffInfoProps) => {
  return (
    <div className="row">
      <div className="col">
        <table className="table table-sm table-striped">
          <tbody>
            <tr>
              <td>To File:</td>
              <td>{diffInfo.toFile}</td>
            </tr>
            <tr>
              <td>From File:</td>
              <td>{diffInfo.fromFile}</td>
            </tr>
            <tr>
              <td>File Status:</td>
              <td>{diffInfo.fileStatus}</td>
            </tr>
            <tr>
              <td>Is Added File:</td>
              <td>{convertToString(diffInfo.addedFile)}</td>
            </tr>
            <tr>
              <td>Is Modified File:</td>
              <td>{convertToString(diffInfo.modifiedFile)}</td>
            </tr>
            <tr>
              <td>Is Removed File:</td>
              <td>{convertToString(diffInfo.removedFile)}</td>
            </tr>
            <tr>
              <td>Is Renamed File:</td>
              <td>{convertToString(diffInfo.renamed)}</td>
            </tr>
            <tr>
              <td>Is Binary File:</td>
              <td>{convertToString(diffInfo.binary)}</td>
            </tr>
            <tr>
              <td>Mode:</td>
              <td>{diffInfo.mode}</td>
            </tr>
            <tr>
              <td>Old Mode:</td>
              <td>{diffInfo.oldMode}</td>
            </tr>
            <tr>
              <td>Checksum Before:</td>
              <td>{diffInfo.checksumBefore}</td>
            </tr>
            <tr>
              <td>Checksum After:</td>
              <td>{diffInfo.checksumAfter}</td>
            </tr>
            <tr>
              <td>Is Copied File:</td>
              <td>{convertToString(diffInfo.copied)}</td>
            </tr>
            <tr>
              <td>Similarity Index:</td>
              <td>{diffInfo.similarityIndex}</td>
            </tr>
            <tr>
              <td>Disimilarity Index:</td>
              <td>{diffInfo.disimilarityIndex}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div className="col">
        <h5>Raw Diff:</h5>
        <textarea
          className="form-control"
          rows={18}
          value={diffInfo.rawDiff}
          readOnly
        />
      </div>
    </div>
  )
}

const convertToString = (obj: any) => {
  if (obj !== null && obj !== undefined) return obj.toString()
}

export default DiffInfoComponent
