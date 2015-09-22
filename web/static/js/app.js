import 'babel-core/polyfill';

import $ from 'jquery';
import Rx from 'rx';
import React from 'react';
import ReactDOM from 'react-dom';

var filesData$ = new Rx.Subject();
var updateFilesData$ = filesData$.map(function (files) {
  return function (state) {
    return Object.assign(state, { files });
  };
});

function loadFilesData() {
  $.get(`${window.API_ROOT}/files`, function (files) {
    filesData$.onNext(files);
  });
}

function getState$() {
  return Rx.Observable.merge(
    updateFilesData$
  ).scan(function (state, scanner) {
    return scanner(state);
  }, {
    files: []
  });
}

function FilesView(props) {
  return (
    <div>
      {props.files.map(file => <div key={file}>{file}</div>)}
    </div>
  );
}

function view(state) {
  return (
    <div>
      <h3>Muh Filez:</h3>
      <FilesView files={state.files}/>
    </div>
  );
}

function init() {
  loadFilesData();
  var appContainer = document.getElementById('app');
  var state$ = getState$();

  state$.subscribe(function (state) {
    ReactDOM.render(view(state), appContainer);
  });
}

init();
