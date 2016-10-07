const electron = require('electron');
const fs = require('fs');
const path = require('path');
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

let mainWindow = null;

// app.on("window-all-closed", function() {
//   if(process.platform !== "darwin") {
//     app.quit();
//   }
// });

// app.on("ready", function() {
//   mainWindow = new BrowserWindow({ width: 800, height: 600 });
//   mainWindow.loadURL("file://" + __dirname + "/build/index.html");
//   mainWindow.openDevTools();
//   mainWindow.on("closed", function() {
//     mainWindow = null;
//   });
// });

const filePath = path.join(__dirname, 'index.js');
console.log(filePath);

// load file
fs.readFile(filePath, 'utf-8', function(err, data) {
  if(err) throw err;
  console.log(data);
});

