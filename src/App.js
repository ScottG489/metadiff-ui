import React, {Component} from 'react';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <DiffInfo/>
      </div>
    );
  }
}

class DiffInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: 'diff --git a/.gitignore b/.gitignore\n' +
        'index feb3e1f..5835ba8 100644\n' +
        '--- a/.gitignore\n' +
        '+++ b/.gitignore\n' +
        '@@ -2,6 +2,7 @@\n' +
        ' build\n' +
        ' out\n' +
        '\n' +
        '+.idea/\n' +
        ' *.iml\n' +
        ' *.ipr\n' +
        ' *.iws',
      response: {}
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    console.log("'" + this.state.value + "'");
    fetch('https://diff-data.com/build?image=scottg489/diff-info:latest', {
      method: 'POST',
      body: this.state.value
    })
      .then(response => {
        return response.json()
      })
      .then(json => {
        console.log(json)
        this.setState({response: json})
      })
      .catch(reason => console.log(reason));
    event.preventDefault();
  }

  render() {
    return (
      <div className="diff-info">
        <h1>Diff Info</h1>
        <form className="text" onSubmit={this.handleSubmit}>
          <textarea value={this.state.value} onChange={this.handleChange}/>
          <input type="submit" value="Submit"/>
        </form>
        <table>
          <tbody>
          <tr>
            <th>To file:</th>
            <th>{this.state.response.toFile}</th>
          </tr>
          <tr>
            <th>From file:</th>
            <th>{this.state.response.fromFile}</th>
          </tr>
          <tr>
            <th>File status:</th>
            <th>{this.state.response.fileStatus}</th>
          </tr>
          <tr>
            <th>Is Added File:</th>
            <th>{DiffInfo.convertToString(this.state.response.addedFile)}</th>
          </tr>
          <tr>
            <th>Is Modified File:</th>
            <th>{DiffInfo.convertToString(this.state.response.modifiedFile)}</th>
          </tr>
          <tr>
            <th>Is Removed File:</th>
            <th>{DiffInfo.convertToString(this.state.response.removedFile)}</th>
          </tr>
          <tr>
            <th>Is Renamed file:</th>
            <th>{DiffInfo.convertToString(this.state.response.renamed)}</th>
          </tr>
          <tr>
            <th>Is Binary File:</th>
            <th>{DiffInfo.convertToString(this.state.response.binary)}</th>
          </tr>
          <tr>
            <th>Mode:</th>
            <th>{this.state.response.mode}</th>
          </tr>
          <tr>
            <th>Old Mode:</th>
            <th>{this.state.response.oldMode}</th>
          </tr>
          <tr>
            <th>Checksum Before:</th>
            <th>{this.state.response.checksumBefore}</th>
          </tr>
          <tr>
            <th>Checksum After:</th>
            <th>{this.state.response.checksumAfter}</th>
          </tr>
          <tr>
            <th>Is Copied File:</th>
            <th>{DiffInfo.convertToString(this.state.response.copied)}</th>
          </tr>
          <tr>
            <th>Similarity Index:</th>
            <th>{this.state.response.similarityIndex}</th>
          </tr>
          <tr>
            <th>Disimilarity Index:</th>
            <th>{this.state.response.disimilarityIndex}</th>
          </tr>
          </tbody>
        </table>
        <div>
          <h3>Raw Diff:</h3>
          <textarea value={this.state.response.rawDiff} readOnly/>
        </div>
      </div>
    )
  }

  static convertToString(obj) {
    if (obj !== null && obj !== undefined) return obj.toString()
  }
}

export default App;
