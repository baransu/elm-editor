const electron = require('electron');
const fs = require('fs');
const path = require('path');
const app = electron.app;
const ipcMain = electron.ipcMain;
const BrowserWindow = electron.BrowserWindow;
const { Menu, dialog } = require('electron');

let mainWindow = null;

app.on("window-all-closed", function() {
  if(process.platform !== "darwin") {
    app.quit();
  }
});

app.on("ready", function() {
  mainWindow = new BrowserWindow({ title: "elm-editor", width: 800, height: 600 });
  mainWindow.loadURL("file://" + __dirname + "/build/index.html");
  mainWindow.openDevTools();
  mainWindow.on("closed", function() {
    mainWindow = null;
  });

  initializeMenu();

});

ipcMain.on("open-file", (event, arg) => {
  openFile(event);
});

function openFile(event = mainWindow.webContents) {
  dialog.showOpenDialog(
    mainWindow,
    { properies: ['openFile'] },
    function(files) {
      if(files === undefined) return false;
      fs.readFile(files[0], 'utf-8', function(err, data) {
        if(err) throw err;
        event.send("open-file", data);
      });
      return true;
  });

}

function initializeMenu() {
  const template = [
    {
      label: app.getName(),
      submenu: [
        { label: "Open File",
          click(item, focusedWindow) {
            if(focusedWindow)
              openFile(focusedWindow.webContents);
            else
              openFile();
          }
        }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);

}
