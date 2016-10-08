const Elm = require('./js/elm.js');
const app = Elm.Main.fullscreen();
const electron = require('electron');
const ipcRenderer = electron.ipcRenderer;

// ports here
app.ports.command.subscribe(function(command) {
  ipcRenderer.send(command);
  ipcRenderer.on(command, function(event, data) {
    app.ports.onCommand.send(data);
  });
});

ipcRenderer.on("open-file", function(event, data) {
  app.ports.onCommand.send(data);
});


// remove arrow and space scroll
window.addEventListener("keydown", function(e) {
  if([32, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
    e.preventDefault();
  }
}, false);
