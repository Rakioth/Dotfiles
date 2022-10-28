/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

$("#run-import-btn").hide(); // hide Apply button instantly. (won't work properly if done from CSS)

// select export-textarea's text on focus
$(document).on("focus mousedown mouseup", "#export-textarea", function(e) {
  e.preventDefault();
  $(this).select();
});

// upon click on import button
$(document).on("click", "#import-btn", function() {
  $("#export-textarea").hide();
  $("#import-textarea").show().focus();
  $("#run-import-btn").show();
});

// upon click on restore button
$(document).on("click", "#restore-btn", function() {
  qTipConfirm("Confirm Restore", "Are you sure you want to restore? Your current settings would be lost.",
    "OK", "Cancel", restore);
});

function restore(callbackReturned) {
  if (callbackReturned === false)
    return;

  const restoreString = localStorage.backupBeforeImport;
  if (restoreString) {
    importLocalStorage(restoreString);
  } else {
    $.jGrowl("Nothing to restore!", { header: "Import/Export" });
  }
}

// upon click on export button
$(document).on("click", "#export-btn", function() {
  $("#import-textarea").hide();
  $("#run-import-btn").hide();
  let $textArea = $("#export-textarea");
  $textArea.show();

  buildExportString(function(export_string){
    $textArea.val(export_string);
    $textArea.select();
  });
});

function buildExportString(callback) {
  storage.get(["tiles", "settings"], function(storage_data) {
    let exportDataObj = {};

    if (storage_data.tiles)
      exportDataObj.tiles = storage_data.tiles;
    if (storage_data.settings_raw)
      exportDataObj.settings = storage_data.settings_raw;

    const base64str = Base64.encode(JSON.stringify(exportDataObj));
    const dateObj = new Date();
    const fullYearVal = dateObj.getFullYear();
    let monthVal = dateObj.getMonth()+1;
    let dateVal = dateObj.getDate();
    if (dateVal<10) {dateVal='0'+dateVal;}
    if (monthVal<10) {monthVal='0'+monthVal;}

    const exportString = '[ANTP_EXPORT|' + fullYearVal + '-' + monthVal + '-' + dateVal + '|' + chrome.app.getDetails().version + '|' + base64str + ']';
    callback(exportString);
  });
}


// upon click on run import button
$(document).on("click", "#import-export-contents #run-import-btn", function() {
  const $textArea = $("#import-textarea");
  const inputStr = $textArea.val().trim();
  if (validateImportString(inputStr)) {
    importLocalStorage(inputStr);
  }
});

function validateImportString(importString) {
  if (importString.length === 0) {
    $.jGrowl("Enter import string first!", { header: "Import/Export" });
    return false;
  } else {
    const stringParts = importString.split('|');
    if (stringParts.length !== 4 || stringParts[0] !== "[ANTP_EXPORT" || (new Date(stringParts[1])).toString() === "Invalid Date" || stringParts[3].length < 1) {
      $.jGrowl("Invalid import string!", { header: "Import/Export" });
      return false;
    } else {
      const antpVersion = stringParts[2].split('.');
      if (antpVersion.length < 3) {
        $.jGrowl("Invalid import string!", { header: "Import/Export" });
        return false;
      }
    }
  }
  return true;
}

function importLocalStorage(importString) {
  buildExportString(function(export_string) {
    localStorage.backupBeforeImport = export_string;
    localStorage.msg = JSON.stringify({
      title: "Backup imported",
      message: "Backup has been imported successfully."
    });

    importString = importString.substring(0, importString.length-1);
    const tArr = importString.split('|');
    const base64str = tArr[tArr.length-1];
    const exportDataObj = JSON.parse(Base64.decode(base64str));

    if (exportDataObj.tiles) {
      storage.set({tiles: exportDataObj.tiles});
      if (exportDataObj.settings) {
        storage.set({settings: exportDataObj.settings});
      }
    } else if (exportDataObj.widgets) {
      storage.set({tiles: JSON.parse(exportDataObj.widgets)});
    }

    window.location.reload();
  });
}
