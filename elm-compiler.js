const nodeElmCompiler = require('node-elm-compiler');
const compile = nodeElmCompiler.compile;

compile(["./src/Main.elm"], {
  output: "./public/js/elm.js"
}).on('close', function(exitCode) {
  console.log("Finished with exit code", exitCode);
});
