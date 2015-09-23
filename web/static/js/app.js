import $ from 'jquery';
import Rx from 'rx';

import Elm from '../elm/App.elm';

var filesData$ = new Rx.Subject();

function loadFilesData() {
  $.get(`${window.API_ROOT}/files`, function (files) {
    filesData$.onNext(files);
  });
}

function init() {
  loadFilesData();

  var appContainer = document.getElementById('app');
  var elmApp = Elm.embed(Elm.App, appContainer, {
    newFiles: []
  });

  filesData$.subscribe(function (files) {
    elmApp.ports.newFiles.send(files);
  });

  elmApp.ports.updateRequests.subscribe(function (value) {
    console.log('update requested');
    loadFilesData();
  });
}

init();
