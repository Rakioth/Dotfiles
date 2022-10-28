/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/


/* START :: Windows */

  $(document).ready(function($) {
    $(".ui-2.container").center();

    $(window).bind('resize scroll', function() {
      $(".ui-2.container").center();
    });
  });

  $(document).on("click", ".close, .ui-2.x", closeButton);

  function closeButton(exclude) {

    if ( exclude && typeof(exclude) === "string" ) {
      $("body > .ui-2").not(exclude).hide();
    } else {
      $("body > .ui-2").hide();
    }

    window.location.hash = "";
    hscroll = true;
  }

let optionsInit = false;
$(document).on("click", "#config-button", function(){
  if ( !optionsInit ) {
    $(window).trigger("antp-config-first-open");
    optionsInit = true;
  }

  // closeButton(".ui-2#config");
  // $(".ui-2#config").toggle();
  requiredColorPicker();
  required('/extension/javascript/import-export.js?nocache=12');
});

  var aboutInit = false;
  $(document).on("click", "#logo-button", function() {

    if ( !aboutInit ) {
      aboutInit = true;

      (function() {
        const twitterScriptTag = document.createElement('script');
        twitterScriptTag.type = 'text/javascript';
        twitterScriptTag.async = true;
        twitterScriptTag.src = 'https://platform.twitter.com/widgets.js';
        const s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(twitterScriptTag, s);
      })();

      $("#fb-root iframe").attr("src", "https://www.facebook.com/plugins/like.php?href=https%3A%2F%2Fwww.facebook.com%2FAwesomeNewTabPage&amp;width=300&amp;layout=standard&amp;action=like&amp;show_faces=true&amp;share=true&amp;height=80");

      (function() {
        const s = document.createElement('script'), t = document.getElementsByTagName('script')[0];
        s.type = 'text/javascript';
        s.async = true;
        s.src = 'https://chrome.google.com/webstore/widget/developer/scripts/widget.js';
        t.parentNode.insertBefore(s, t);
      })();
    }
  });

  $(document).on("click", ".drawer-app-uninstall", function(e) {
    let to_delete = $(this).parent();
    let to_delete_name = $(to_delete).find(".drawer-app-name").attr("data-name");

    function uninstall(callbackReturned) {
      if ( callbackReturned === false )
        return;
      chrome.management.uninstall($(to_delete).attr("id"));
    }

    qTipConfirm("Uninstall app or extension", `Are you sure you want to uninstall ${to_delete_name} from your browser?`,
      "OK", "Cancel", uninstall);

    return false;
  });

/* END :: Windows */

/* START :: Top Left Buttons */

$(window).bind("antp-config-first-open", function () {
  storage.get("settings", function (storage_data) {
    $("#hideLeftButtons").prop("checked", storage_data.settings.buttons);
    $(document).on("change", "#hideLeftButtons", moveLeftButtons);
  });
});

function moveLeftButtons(e) {
  storage.get("settings", function (storage_data) {
    if (e) {
      settings.set({"buttons": $("#hideLeftButtons").is(":checked")});
      storage_data.settings.buttons = $("#hideLeftButtons").is(":checked");
    }

    if (!storage_data.settings.buttons && storage_data.settings.lock) {
      $("#top-buttons > div").css("left", "-50px");
      window.GRID_MARGIN_LEFT = 0;
      window.moveGrid(true);
    }

    if (storage_data.settings.buttons) {
      $("#top-buttons > div").css("left", "0px");
      window.GRID_MARGIN_LEFT = 32;
      window.moveGrid(true);
    }
  });
}

$(document).ready(function ($) {
  moveLeftButtons();
});

$(document).on({
  mouseenter: function () {
    storage.get("settings", function (storage_data) {
      if (!storage_data.settings.buttons) {
        $("#top-buttons > div").css("left", "0px");
        window.GRID_MARGIN_LEFT = 32;
        window.moveGrid(true);
      }
    });
  },
  mouseleave: function () {
    storage.get("settings", function (storage_data) {
      if (!storage_data.settings.buttons && storage_data.settings.lock) {
        $("#top-buttons > div").css("left", "-50px");
        window.GRID_MARGIN_LEFT = 0;
        window.moveGrid(true);
      }
    });
  }
}, "#top-buttons");

/* END :: Top Left Buttons */

/* START :: Configure */

$(document).ready(function ($) {
  if (window.location.hash) {
    switch (window.location.hash) {
      case "#options":
        $("#config-button").trigger("click");
        break;
    }
  }

  if (localStorage.getItem("bg-img-css") === "url(/extension/images/default_bg.png) top center") {
    localStorage.setItem("bg-img-css", "url(/extension/images/default_bg.jpg) top center");
  }

  if (localStorage.getItem("bg-img-css") === null) {
    localStorage.setItem("bg-img-css", "url(/extension/images/default_bg.jpg) top center");
  }

  if (localStorage.getItem("bg-img-css") && localStorage.getItem("bg-img-css") !== "") {
    $("body").css("background", localStorage.getItem("bg-img-css"));
  }
});

  $(".bg-color").css("background-color", "#" + (localStorage.getItem("color-bg") || "221f20"));

  $(document).ready(function($) {
    $(".bg-color").css("background-color", "#" + (localStorage.getItem("color-bg") || "221f20"));
  });

  $(document).on("keyup change", "#bg-img-css", function() {
    $("body").css("background", "" );
    $("body").css("background", $(this).val() );
    $(".bg-color").css("background-color", '#' + (localStorage.getItem("color-bg") || "221f20") );

    if($(this).val() === "") {
      $(".bg-color").css("background-color", "#" + (localStorage.getItem("color-bg") || "221f20"));
    }

    localStorage.setItem("bg-img-css", $(this).val() );
  });

  $(document).on("click", "#reset-button", function() {
    function reset(callbackReturned) {
      if (callbackReturned === false) {
        $.jGrowl("Whew! Crisis averted!", { header: "Reset Cancelled" });
        return;
      }

      deleteShortcuts();
      deleteRoot();
      localStorage.clear();
      storage.clear()

      setTimeout(function() {
        reload();
      }, 250);
    }

    qTipConfirm("Reset", "Are you sure you want to reset widget, app, and custom shortcut placements, stock widget preferences (notepad, etc.), and background preferences? Any customizations will be irrevocably lost.",
      "OK", "Cancel", reset);
  });

  $(window).bind("antp-config-first-open", function() {
    storage.get("settings", function(storage_data) {
      $("#grid_width").val(storage_data.settings.grid_width);
      $("#grid_height").val(storage_data.settings.grid_height);
      $(document).on("change keyup", "#grid_width, #grid_height", updateGridSize);
    });
  });

  function updateGridSize(e) {
    if ( e ) {
      let value = $(this).val();

      const toSet = {};
      if ( value === "" ) {
        toSet[$(this).attr("id")] = null;
        settings.set(toSet, function() {
          storage.get(["tiles", "settings"], placeGrid);
          $(window).trigger("antp-widgets");
        });
        return;
      }

      if ($(this).attr("id") === "grid_width") {
        value  = (value < 4) ? 4 : value;
        value  = (value > 50) ? 50 : value;
        $(this).val(value);
      }

      if ($(this).attr("id") === "grid_height") {
        value = (value < 3) ? 3 : value;
        value = (value > 25) ? 25 : value;
        $(this).val(value);
      }

      toSet[$(this).attr("id")] = $(this).val();
      settings.set(toSet, function () {
        storage.get(["tiles", "settings"], placeGrid);
        $(window).trigger("antp-widgets");
      });

      window.onWindowResizeHandler();
    }
  }

  /* END :: Configure */

/* START :: Hide RCTM */

  $(window).bind("antp-config-first-open", function() {
    storage.get("settings", function(storage_data) {
      $("#hideRCTM").prop("checked", storage_data.settings.recently_closed);
      $(document).on("change", "#hideRCTM", updateRCTMVisibility);
    });
  });

  function updateRCTMVisibility(e) {
    storage.get("settings", function(storage_data) {
      if ( e ) {
        settings.set({"recently_closed": $("#hideRCTM").is(":checked")});
        storage_data.settings.recently_closed = $("#hideRCTM").is(":checked");
      }

      if ( storage_data.settings.recently_closed ) {
        $("#recently-closed-tabs").show();
      } else {
        $("#recently-closed-tabs").hide();
      }
    });
  }
  updateRCTMVisibility();

  /* END :: Hide RCTM */

function colorPickerLoaded() {
  $(document).on("mouseenter", "#colorselector-bg", function(e) {
    // background color picker
    $("#colorselector-bg").ColorPicker({
      color: '#' + (localStorage.getItem("color-bg") || "221f20"),
      onShow: function (colpkr) {
        $(colpkr).fadeIn(500);
        return false;
      },
      onHide: function (colpkr) {
        $(colpkr).fadeOut(500);
        return false;
      },
      onChange: function (hsb, hex, rgb) {
        $(".bg-color").css('background-color', '#' + hex);
        localStorage.setItem("color-bg", hex);
      }
    });
  });
}


$(document).ready(function() {
  $('div[title]').qtip({
    style: {
      classes: 'qtip-light qtip-shadow qtip-bootstrap'
    }
  });
});

function qTipAlert(title, message, buttonText) {
  message = $('<span />', { text: message }),
    ok = $('<button />', { text: buttonText, 'class': 'bubble' }).css("width", "100%");

  dialogue( message.add(ok), title );
}

function qTipConfirm(title, message, buttonTextOk, buttonTextCancel, callback) {
  message = $('<span />', { text: message })
  let ok = $('<button />', {
      text: buttonTextOk,
      click: function() { callback(true); },
      class: 'bubble ilb'
    }).css({"width": "45%", "float": "left"})
  let cancel = $('<button />', {
      text: buttonTextCancel,
      click: function() { callback(false); },
      class: 'bubble ilb'
    }).css({"width": "45%", "float": "right"});

  dialogue( message.add(ok).add(cancel), title );
}

function dialogue(content, title) {
  $('<div />').qtip({
    content: {
      text: content,
      title: {
        text: "<b>" + title + "</b>",
        button: false
      }
    },
    position: {
      my: 'center',
      at: 'center',
      target: $(window)
    },
    show: {
      ready: true,
      modal: {
        on: true,
        blur: false
      }
    },
    hide: false,
    style: 'qtip-light qtip-rounded qtip-bootstrap qtip-dialogue',
    events: {
      render: function(event, api) {
        $('button', api.elements.content).click(function(){api.destroy();});
      }
    }
  });
}
