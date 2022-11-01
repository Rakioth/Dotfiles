/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

// Create shortcut on click
function createShortcut(tile) {
  const new_shortcut_id = new_guid();

  storage.get("tiles", function(storage_data) {
    addShortcut(
      new_shortcut_id,
      $(tile).attr("land-top"),
      $(tile).attr("land-left"),
      storage_data);

    setTimeout(function() {
      $("#" + new_shortcut_id).find(".iframe-mask").find("#shortcut-edit").trigger("click");
    }, 100);

    $(tile).removeClass("add-shortcut").removeClass("empty");
  });
}

// Adds shortcut
function addShortcut(widget, top, left, storage_data) {
  let widgets = storage_data.tiles;

  widgets[widget] = {
    where: [top,left],
    size: [1,1],
    type: "shortcut",
    isApp: false,
    name: "Google",
    id: widget,
    img: "https://static.antp.co/shortcuts/new_shortcut_star.svg",
    appLaunchUrl: "https://www.google.com/",
    url: "https://www.google.com/",
    color: palette[Math.floor(Math.random() * palette.length)],
    name_show: true,
    favicon_show: true
  };

  storage.set({tiles: widgets}, function() {
    $(window).trigger("antp-widgets");
  });
}
