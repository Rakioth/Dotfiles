requirejs.config({
    baseUrl: 'extension/javascript',
    paths: {
        app: '/colorpicker'
    }
});

function required(file, callback) {
  if (!require.defined(file)) {
    require([file], function() {
      if (callback)
        callback(true);
    });
  }
  else if (callback)
    callback(false);
}

function requiredColorPicker(callback) {
  required('/extension/colorpicker/js/colorpicker.js', function(loaded) {
    if (loaded)
      colorPickerLoaded();
    if (callback)
      callback();
  });
}

function requiredTutorial() {
  required('/extension/javascript/tutorial.js', function(loaded) {
    if (loaded)
      startTutorial();
  });
}

$(document).ready(function() {
  setTimeout(function() {
    require(["filesystem"]);
  }, 1000);
});
