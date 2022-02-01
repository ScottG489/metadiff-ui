export interface DiffInfoFormStore {
  diffInputText: string;
  diffInfos: DiffInfo[];
}

export interface DiffInfo {
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
