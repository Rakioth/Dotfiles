/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

/* START :: Online/Offline status */

  if (!navigator.onLine) {
    $("body").addClass("offline");
  }

  $(document).bind("online", function () {
    $("body").removeClass("offline");
  });
  $(document).bind("offline", function () {
    $("body").addClass("offline");
  });

  /* END :: Online/Offline status */

/* START :: Show/Hide Grid */

  $(window).bind("antp-config-first-open", function() {
    storage.get("settings", function(storage_data) {
      $("#toggle-grid").prop("checked", storage_data.settings.grid);
      $(document).on("change", "#toggle-grid", updateGridOpacity);
    });
  });

function updateGridOpacity(e) {
    storage.get("settings", function(storage_data) {
      if ( e ) {
        settings.set({"grid": $("#toggle-grid").is(":checked")});
        storage_data.settings.grid = $("#toggle-grid").is(":checked");
      }

      if ( storage_data.settings.grid ) {
        $("body").addClass("perm-grid");
      } else {
        $("body").removeClass("perm-grid");
      }
    });
  }

  /* END :: Show/Hide Grid */

$(document).ready(function() {
  storage.get(["tiles", "settings"], placeGrid);
});

const
  GRID_MIN_HEIGHT = 3,
  GRID_MIN_WIDTH = 5,
  GRID_MARGIN_TOP = 0,
  GRID_TILE_SIZE = 175,
  GRID_TILE_PADDING = 5,

  TILE_MIN_WIDTH = 1, // individual tile min width
  TILE_MAX_WIDTH = 3, // individual tile max width
  TILE_MIN_HEIGHT = 1, // individual tile min height
  TILE_MAX_HEIGHT = 3, // individual tile max height

  EXTRA_HEIGHT = 3, // how many extra rows to generate of empty tiles
  EXTRA_WIDTH = 0, // how many extra columns to generate of empty tiles

  TILES_MIN_HEIGHT = 4, // min rows
  TILES_MIN_WIDTH = 3; // min columns

window.GRID_MARGIN_LEFT = 32;
let MUTABLE_MARGIN_LEFT = 0; // for future

function clamp(current, min, max) {
  return Math.min(Math.max(current, min), max);
}

function calcSide(size) {
  return (GRID_TILE_SIZE * size) + ((GRID_TILE_PADDING * 2) * (size - 1));
}

// Handles positioning and repositioning the grid
function moveGrid(resize) {
  const widgetHolder = $("#widget-holder,#grid-holder");

  widgetHolder.css({
    top: GRID_MARGIN_TOP,
    left: GRID_MARGIN_LEFT + MUTABLE_MARGIN_LEFT
  });

  updateGridOpacity();
  if (resize) {
    window.onWindowResizeHandler();
  }
}

let tileWidthOfGrid;
window.onWindowResizeHandler = function () {
  const pixelWidthOfGrid = tileWidthOfGrid * (GRID_TILE_SIZE + (GRID_TILE_PADDING * 2)) + (3 * 2); // 3px margin
  const horizontalPixelsRequired = pixelWidthOfGrid + GRID_MARGIN_LEFT;
  const horizontalPixelsAvailable = window.innerWidth;

  // if grid is smaller than horizontal view
  if (horizontalPixelsRequired < horizontalPixelsAvailable) {
    let left = (horizontalPixelsAvailable - horizontalPixelsRequired) / 2;
    MUTABLE_MARGIN_LEFT = left;
    moveGrid(false)
  } else {
    MUTABLE_MARGIN_LEFT = 0;
    moveGrid(false)
  }
}

function placeGrid(storage_data) {
  $("#grid-holder").empty();
  moveGrid(true);
  const tile_template = '<li class="tile empty">&nbsp;</li>';

  let height = GRID_MIN_HEIGHT;
  let width = GRID_MIN_WIDTH;

  // Ensure window is filled with grid tiles
  if (typeof (window.innerHeight) !== "undefined"
    && typeof (window.innerWidth) !== "undefined") {
    const res_height = Math.floor((window.innerHeight - GRID_MARGIN_TOP) / (GRID_TILE_SIZE + (GRID_TILE_PADDING * 2))) + EXTRA_HEIGHT;
    const res_width = Math.floor((window.innerWidth - GRID_MARGIN_LEFT) / (GRID_TILE_SIZE + (GRID_TILE_PADDING * 2))) + EXTRA_WIDTH;

    height = Math.max(res_height, height);
    width = Math.max(res_width, width);
  }

  const tiles = storage_data.tiles;
  let placed_height = 0, placed_width = 0;

  // Ensure all placed widgets have a grid tile to land on
  if (typeof tiles === "object") {
    $.each(tiles, function (id, widget) {
      placed_height = Math.max(placed_height, parseFloat(widget.where[0]) + parseFloat(widget.size[0]) + EXTRA_HEIGHT)
      placed_width = Math.max(placed_width, parseFloat(widget.where[1]) + parseFloat(widget.size[1]) + EXTRA_WIDTH);
    });

    height = Math.max(height, placed_height);
    width = Math.max(width, placed_width);
  }

  if (parseInt(storage_data.settings.grid_width) % 1 === 0)
    width = Math.max(parseInt(storage_data.settings.grid_width), TILES_MIN_WIDTH);

  if (parseInt(storage_data.settings.grid_height) % 1 === 0)
    height = Math.max(parseInt(storage_data.settings.grid_height), TILES_MIN_HEIGHT);

  // For performance reasons, never allow the grid to get excessively
  height = Math.min(height, 25); //  5,144 px
  width = Math.min(width, 50); // 10,294 px

  tileWidthOfGrid = width;

  // Actually place the grid
  for (let gx = 0; gx < height; gx++) {
    for (let gy = 0; gy < width; gy++) {
      $(tile_template).css({
        "position": "absolute",
        "top": (gx * GRID_TILE_SIZE) + ((GRID_TILE_PADDING * 2) * (gx + 1)),
        "left": (gy * GRID_TILE_SIZE) + ((GRID_TILE_PADDING * 2) * (gy + 1))
      }).attr("id", gx + "x" + gy).attr({
        "land-top": gx,
        "land-left": gy
      }).appendTo("#grid-holder");
    }
  }

  updateGridOpacity();
  window.onWindowResizeHandler()
}

$(document).on({
  mouseenter: function() {
    $(this).addClass("add-shortcut");
  },
  mouseleave: function() {
    $(".tile").removeClass("add-shortcut");
  }
}, ".empty");

let update = true;

function findClosest(tile){
  let closestElm = null;
  let thisTile = $(tile).offset();
  const boxX = thisTile.left,
        boxY = thisTile.top;
  let distElm = -1;
  $(".tile").each(function(ind, elem){
    let thisElem = $(elem).offset();
    const closeX = thisElem.left,
          closeY = thisElem.top;
    let testElm = Math.pow(boxX - closeX, 2) + Math.pow(boxY - closeY, 2);
    if(testElm < distElm || distElm === -1){
      distElm = testElm;
      closestElm = elem;
    }
  });
  return closestElm;
}

function getCovered(tile) {
  const toRet = {};
  toRet.clear = true;
  toRet.tiles = [];
  const closestElm = findClosest(tile);

  const top = parseInt($(closestElm).attr("land-top"));
  const left = parseInt($(closestElm).attr("land-left"));

  const height = parseInt($(tile).attr("tile-height"));
  const width = parseInt($(tile).attr("tile-width"));
  for (let h=0; h<=(height-1); h++)
  {
    for (let w=0; w<=(width-1); w++)
    {
      const temporary_tile = $("#" + (top + h) + "x" + (left + w) + ".tile")[0];
      if( temporary_tile ) {
        (toRet.tiles).push( temporary_tile );

        if($( temporary_tile ).hasClass("empty") === false) {
          toRet.clear = false;
        }
      } else {
        toRet.clear = false;
      }
    }
  }

  return toRet;
}

// Trigger mouseup on escape key
$(document).keyup(function(e) {
  if (e.which === 27) {
    if ( typeof(held_element.element) === "object" ) {
      $(held_element.element).trigger("mouseup");
    }
    if ( typeof(resize_element.element) === "object" )
    $(".resize-tile > div").trigger("mouseup");

    // Close all UI-2 elements
    $(".ui-2.x").trigger("click");
  }
});

// Trigger mouseup if during a resize the mouseup isn't on a resize div
$(document).mouseup(function() {
  if ( typeof(resize_element.element) === "object" ) {
    $(".resize-tile > div").trigger("mouseup");
  }
});

/* START :: Resize */

  resize_element = {};
  resize_element.element = false;
  // When a tile resize square is clicked
  $(document).on("mousedown", ".resize-tile > div", function(e) {
    const $element = $(this);
    storage.get("tiles", function(storage_data) {
      if ( lock === true ) {
        resize_element.element = false;
        return false;
      }

      $(".ui-2.x").trigger("click");

      switch ( $element.attr("class") ) {
        case "resize-tile-top":
          resize_element.side = "top";    break;
        case "resize-tile-bottom":
          resize_element.side = "bottom"; break;
        case "resize-tile-left":
          resize_element.side = "left";   break;
        case "resize-tile-right":
          resize_element.side = "right";  break;
        default:
          return console.error("Resize Mousedown", "Invalid side.");
      }
      let widgets = storage_data.tiles;


      resize_element.element = $element.closest(".widget")[0];
      const id = $(resize_element.element).attr("id");

      // Ensure apps/custom shortcuts are resizable
      if ( widgets[id].type
      && (widgets[id].type === "shortcut" || widgets[id].type === "app") ) {
        widgets[id].resize = true;
        widgets[id].v2 = {};
        widgets[id].v2.min_width  = 1;
        widgets[id].v2.max_width  = 2;
        widgets[id].v2.min_height = 1;
        widgets[id].v2.max_height = 2;
      }

      if ( typeof(widgets[id]) === "object"
        && typeof(widgets[id].resize) === "boolean"
        && typeof(widgets[id].v2) === "object"
        && widgets[id].resize === true ) {
        resize_element.v2         = widgets[id].v2;
      } else {
        resize_element.element = false;
        return console.error("Resize Mousedown", resize_element.side, "Tile storage discrepancy; tile not resizable.");
      }

      resize_element.top     = $(resize_element.element).position().top;
      resize_element.left    = $(resize_element.element).position().left;
      resize_element.width   = $(resize_element.element).width();
      resize_element.height  = $(resize_element.element).height();
      resize_element.clientX = e.clientX;
      resize_element.clientY = e.clientY;
      resize_element.tileH   = $(resize_element.element).attr("tile-height");
      resize_element.tileW   = $(resize_element.element).attr("tile-width");
      resize_element.moved_left = 0;
      resize_element.moved_top  = 0;

      $(getCovered( resize_element.element ).tiles).addClass("empty");

      $(resize_element.element).find("#shortcut-edit,#delete,#widget-config").addClass("force-hide");

      $(resize_element.element)
        .addClass("widget-resize");
      });
    e.preventDefault();
    e.stopPropagation();
  });

  // When a tile resize square is released
  $(document).on("mousemove", function(e) {
    if ( lock === true ) {
      resize_element.element = false;
      return;
    }

    if ( typeof(resize_element.element) !== "object" ) {
      return;
    }

    let new_width = 0;
    let new_height = 0;
    switch ( resize_element.side ) {
      case "top":
        new_height = ( resize_element.clientY - e.clientY ) + resize_element.height;
        let new_top = resize_element.top - (resize_element.clientY - e.clientY);

        new_height = calcHeight({
          "height": new_height,
          "min"  : resize_element.v2.min_height,
          "max"  : resize_element.v2.max_height
        });

        if ( new_height.height <= calcHeight({"is": resize_element.v2.min_height}).height
          || new_height.height >= calcHeight({"is": resize_element.v2.max_height}).height ) return;

        resize_element.moved_top = ( resize_element.clientY - e.clientY );

        if( new_top < (GRID_TILE_PADDING*2) ) {
          new_top = (GRID_TILE_PADDING*2);
          return;
        }

        $(resize_element.element).css({
          "height" : new_height.height,
          "top"  : new_top
        }).attr({"tile-height": new_height.new_y});

        break;
      case "bottom":
        new_height = ( e.clientY - resize_element.clientY ) + resize_element.height;

        new_height = calcHeight({
          "height": new_height,
          "min"  : resize_element.v2.min_height,
          "max"  : resize_element.v2.max_height
        });

        $(resize_element.element).css({
          "height" : new_height.height
        }).attr({"tile-height": new_height.new_y});

        break;
      case "left":
        new_width = ( resize_element.clientX - e.clientX ) + resize_element.width;
        let new_left = resize_element.left - (resize_element.clientX - e.clientX);

        new_width = calcWidth({
          "width": new_width,
          "min"  : resize_element.v2.min_width,
          "max"  : resize_element.v2.max_width
        });

        if ( new_width.width <= calcWidth({"is": resize_element.v2.min_width}).width
          || new_width.width >= calcWidth({"is": resize_element.v2.max_width}).width ) return;

        resize_element.moved_left = ( resize_element.clientX - e.clientX );

        if( new_left < (GRID_TILE_PADDING*2) ) {
          new_left = (GRID_TILE_PADDING*2);
          return;
        }

        $(resize_element.element).css({
          "width" : new_width.width,
          "left"  : new_left
        }).attr({"tile-width": new_width.new_x});

        break;
      case "right":
        new_width = ( e.clientX - resize_element.clientX ) + resize_element.width;

        new_width = calcWidth({
          "width": new_width,
          "min"  : resize_element.v2.min_width,
          "max"  : resize_element.v2.max_width
        });

        $(resize_element.element).css({
          "width" : new_width.width
        }).attr({"tile-width": new_width.new_x});

        break;
    }
  });

  function calcWidth(obj) {
    if ( obj.width === undefined ) obj.width = 0;
    if ( obj.is !== undefined) obj.min = obj.max = obj.is;
    obj.min = clamp(obj.min, TILE_MIN_WIDTH, obj.min );
    obj.max = clamp(obj.max, TILE_MAX_WIDTH, obj.max );
    obj.width = clamp(obj.width, calcSide(obj.min), calcSide(obj.max))

    return {
      "width" : obj.width,
      "new_x" : Math.round( obj.width / (GRID_TILE_SIZE + (GRID_TILE_PADDING * 2)) )
    };
  }

  function calcHeight(obj) {
    if ( obj.height === undefined ) obj.height = 0;
    if ( obj.is !== undefined) obj.min = obj.max = obj.is;
    obj.min = clamp(obj.min, TILE_MIN_HEIGHT, obj.min);
    obj.max = clamp(obj.max, TILE_MAX_HEIGHT, obj.max);
    obj.height = clamp(obj.height, calcSide(obj.min), calcSide(obj.max));

    return {
      "height" : obj.height,
      "new_y" : Math.round( obj.height / (GRID_TILE_SIZE + (GRID_TILE_PADDING * 2)) )
    };
  }

  // When a tile resize square is released
  $(document).on("mouseup", ".resize-tile > div, .widget", function(e) {
    if ( lock === true ) {
      resize_element.element = false;
      return false;
    }

    if ( typeof(resize_element.element) !== "object" ) {
      return;
    }

    const left = $(resize_element.element).position().left;
    let column, bracket;
    let new_left;
    for (let col = 1; col < 50; col++) {
      bracket = ((GRID_TILE_SIZE * col) + (GRID_TILE_PADDING * 2) * col) + (GRID_TILE_PADDING * 2);
      if (bracket > left + 103) {
        new_left = ((GRID_TILE_SIZE * (col - 1)) + (GRID_TILE_PADDING * 2) * (col - 1)) + (GRID_TILE_PADDING * 2);

        column = col - 1;

        $(resize_element.element).css({
          "left": new_left
        }).attr("land-left", col);
        break;
      }
    }

    const top = $(resize_element.element).position().top;
    let row;
    let new_top;
    for (let _row = 1; _row < 50; _row++) {
      bracket = ((GRID_TILE_SIZE * _row) + (GRID_TILE_PADDING * 2) * _row) + (GRID_TILE_PADDING * 2);
      if (bracket > top + 103) {
        new_top = ((GRID_TILE_SIZE * (_row - 1)) + (GRID_TILE_PADDING * 2) * (_row - 1)) + (GRID_TILE_PADDING * 2);

        row = _row - 1;

        $(resize_element.element).css({
          "top": new_top
        }).attr("land-top", _row);
        break;
      }
    }

    $(resize_element.element).css({
      "width" : calcWidth ({"is": $(resize_element.element).attr("tile-width")  }).width,
      "height": calcHeight({"is": $(resize_element.element).attr("tile-height") }).height
    }).removeClass("widget-resize");

    if ( getCovered( resize_element.element ).clear === true ) {
      updateWidget({
        "id"    : $(resize_element.element).attr("id"),
        "width" : $(resize_element.element).attr("tile-width"),
        "height": $(resize_element.element).attr("tile-height"),
        "left"  : column,
        "top"   : row
      });
    } else {
      $(resize_element.element).css({
        "width" : resize_element.width,
        "height": resize_element.height,
        "left"  : resize_element.left,
        "top"   : resize_element.top
      }).attr({
        "tile-width" : resize_element.tileW,
        "tile-height": resize_element.tileH
      });
    }

    $(getCovered( resize_element.element ).tiles).removeClass("empty");

    $(resize_element.element).find("#shortcut-edit,#delete,#widget-config").removeClass("force-hide");

    resize_element.element = false;

    e.preventDefault();
    e.stopPropagation();
  });

  /* END :: Resize */

/* START :: Move */

  let held_element = {};

  held_element.element = false;
  // When a tile is picked up
  $(document).on("mousedown", ".widget", function(e) {
    if(lock === true) {
      held_element.element = false;
      return false;
    }

    $(".ui-2.x").trigger("click");

    $(".widget").css("z-index", "1");

    held_element.offsetX          = e.offsetX;
    held_element.offsetY          = e.offsetY;
    held_element.oldX             = $(this).position().left;
    held_element.oldY             = $(this).position().top;
    held_element.width            = $(this).width();
    held_element.height           = $(this).height();
    held_element.startingMousePos = {left: e.pageX, top: e.pageY};

    if( $(this).attr("app-source") === "from-drawer" ) {
      held_element.element = $(this).clone()
        .addClass("widget-drag").css({
          "position": "absolute",
          "z-index" : "100"
      }).prependTo("body");

        // Ensure that it's always droppable
      held_element.offsetX_required = $(held_element.element).width()  / 2;
    } else {
      const tiles = getCovered(this);
      $(tiles.tiles).each(function(ind, elem){
        $(elem).toggleClass("empty", true);
      });

      $(this).addClass("widget-drag")
        .css("z-index", "100");

      held_element.element = this;
      // since #grid-holder centers itself horizontally in the page sometimes...
      held_element.offsetX_required = $('#grid-holder').position().left + ($(held_element.element).width() / 2);
    }

    held_element.offsetY_required = $(held_element.element).height() / 2;

    // Ensure that it's always droppable
    $(held_element.element).css({
      "left": e.pageX - held_element.offsetX_required,
      "top" : e.pageY - held_element.offsetY_required,
    });

    $(".resize-tile").css("display", "none");
    $(this).find(".resize-tile").css("display", "block");

    if ( e.preventDefault ) {
      e.preventDefault();
    }
  });

  // When a tile is released
  $(document).on("mouseup", ".widget", function(e) {
    if ( lock === true ) {
      held_element.element = false;
      return false;
    }
    if ( held_element.element === false ) {
      return false;
    }

    update = true;

    const closestElm = findClosest(this);
    let tiles = getCovered(this);

    if (tiles.clear === true) {
      let id = $(this).attr("id");

      if ($(this).attr("app-source") === "from-drawer") {

        storage.get("tiles", function (storage_data) {
          addWidget(id, {
            top: $(closestElm).attr("land-top"),
            left: $(closestElm).attr("land-left")
          }, storage_data);
        });

        $(`#widget-holder > #${id}`)
            .attr('tile-width', $(this).attr('tile-width'))
            .attr('tile-height', $(this).attr('tile-height'))
      }

      if ($(this).attr("app-source") !== "from-drawer") {
        updateWidget({
          "id": id,
          "top": $(closestElm).attr("land-top"),
          "left": $(closestElm).attr("land-left")
        });
      }

      $(this).removeClass("widget-drag").css({
        "left": $(closestElm).position().left,
        "top": $(closestElm).position().top,
        "z-index": "2"
      });

      $(tiles.tiles).each(function (ind, elem) {
        $(elem).toggleClass("empty", false);
      });

    } else { // If the tile was full
      if (e.pageX === held_element.startingMousePos.left && e.pageY === held_element.startingMousePos.top) {
        $.jGrowl("To place a widget, click and drag the widget to an empty tile.");
      }

      $(held_element.element).removeClass("widget-drag").css({
        "left": held_element.oldX,
        "top": held_element.oldY,
        "z-index": "2"
      });

      tiles = getCovered(this);

      $(tiles.tiles).each(function (ind, elem) {
        $(elem).toggleClass("empty", false);
      });
    }

    if ( $(held_element.element).attr("app-source") === "from-drawer") {
      $(held_element.element).remove();
    }
    $("body > .widget-drag").remove();

    held_element.element = false;
    $(".tile").removeClass("tile-green tile-red")
      .css("z-index", "0");
  });

  // When a tile is held and moved
  $(document).on("mousemove", function(e) {
    if(lock === true) {
      held_element.element = false;
      return;
    }
    if ( held_element.element === false ) {
      return;
    }

    if (typeof (held_element.element) === "object") {
      if (update === true) {
        update = false;
      } else {

        $(held_element.element).css({
          "left": e.pageX - held_element.offsetX_required,
          "top": e.pageY - held_element.offsetY_required
        });
      }

      hscroll = true;

      const tiles = getCovered(held_element.element);

      $(".tile").removeClass("tile-green tile-red")
          .css("z-index", "0");

      if (tiles.clear === true) {
        $(tiles.tiles).each(function (ind, elem) {
          $(elem).addClass("tile-green")
              .css("z-index", "2");
        });
      } else {
        $(tiles.tiles).each(function (ind, elem) {
          $(elem).addClass("tile-red")
              .css("z-index", "2");
        });
      }
    }
  });
  /* END :: Move */

/* START :: Lock */
  let lock = true;

  $(document).on("click", "#lock-button,#unlock-button", function() {
    let locked = localStorage.getItem("locked") === "true";
    if (locked)  {
      window.__unlock();
    } else {
      window.__lock();
    }
  });

  window.__lock = function() {
    // Lock
    lock = true;
    localStorage.setItem("locked", "true");

    document.body.classList.remove('unlocked');
    document.body.classList.add('locked');

    $(".resize-tile").hide();

    $(".ui-2.x").trigger("click");

    $(".tile").removeClass("tile-grid");

    disableUrls();
  }

  window.__unlock = function() {
    storage.get("settings", function(storage_data) {
      // Unlock
      hscroll = true;
      lock = false;
      localStorage.setItem("locked", "false");

      document.body.classList.remove('locked');
      document.body.classList.add('unlocked');

      $(".tile").addClass("tile-grid");

      disableUrls();

      if (!storage_data.settings.buttons) {
        $(".side-button").css("left", "0px");
        // $("#widget-holder,#grid-holder").css("left", "32px");
        this.onWindowResizeHandler();
      }
    });
  }


  function disableUrls() {
    if($("body").hasClass("unlocked")) {
      $(".drawer-app .url").removeClass("url").addClass("disabled-url");
      setTimeout(function() {
        $(".drawer-app .url").removeClass("url").addClass("disabled-url");
      }, 1100);
    } else {
      $(".drawer-app .disabled-url").removeClass("disabled-url").addClass("url");
      setTimeout(function() {
        $(".drawer-app .disabled-url").removeClass("disabled-url").addClass("url");
      }, 1100);
    }
  }

  /* END :: Lock */

/* START :: Tile-Editor UI Interaction */

  $(document).on("click", "#delete", function() {
    const to_delete = $(this).parent().parent().parent();
    storage.get("tiles", function(storage_data) {
      const widgets = storage_data.tiles;

      if ( to_delete ) {
        const id = $(to_delete).attr("id");

        if ( widgets[id]
          && widgets[id].type === "shortcut"
          && (widgets[id].img).match("filesystem:") ) {

          deleteShortcut( (widgets[id].img).match(/^(.*)\/(.*)/)[2] ); // from filesystem
        }

        $(".ui-2.x").trigger("click");

        removeWidget( $(to_delete).attr("id") );

        const tiles = getCovered(to_delete);
        $(tiles.tiles).each(function(ind, elem){
            $(elem).addClass("empty");
        });

        $(to_delete).remove();

      }
    });
  });

  $(document).on("click", ".unlocked .empty.add-shortcut", function(e) {
    const tile = this;
    createShortcut(tile);
  });

  // Stop edit or delete buttons from interacting with the shortcut/app
  $(document).on("mousedown mouseup move", "#delete,#shortcut-edit,#widget-config", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });

  /* END :: Tile-Editor UI Interaction */


// Add widget to localStorage then refresh
function addWidget(widget_id, tile_location, storage_data) {
  let widgets = storage_data.tiles;


  let scope = angular.element("[ng-controller='windowAppsWidgetsCtrl']").scope(),
      installedWidgets = scope.widgets,
      installedApps = scope.apps,
      externalWidgets = scope.external_widgets,
      obj = externalWidgets[widget_id] || installedWidgets[widget_id] || installedApps[widget_id],
      widget = {id: obj.id, name: obj.name, where: [tile_location.top, tile_location.left], size: [obj.height, obj.width], img: obj.img, color: obj.color};

  widget.size[0] = clamp(widget.size[0] || 1, TILE_MIN_HEIGHT, TILE_MAX_HEIGHT)
  widget.size[1] = clamp(widget.size[1] || 1, TILE_MIN_WIDTH, TILE_MAX_WIDTH)

  if (obj.isApp) {
    widget.offlineEnabled = obj.offlineEnabled;
    widget.appLaunchUrl = widget.url = obj.appLaunchUrl;
    widget.type = "app";
    widget.name_show = !obj.stock; // default false for stock tiles ONLY
    widget.favicon_show = !obj.stock; // default false for stock tiles ONLY
    widget.color = widget.color || palette[Math.floor(Math.random() * palette.length)];
    widget.resize = true;
    widget.v2 = {
        "min_width" : 1,
        "max_width" : 2,
        "min_height": 1,
        "max_height": 2
      }
    widgets[widget.id] = widget;
  } else if (obj.installed || obj.stock) {
    let extensionID = chrome.extension.getURL("").substr(19, 32);
    if ( widget.id === extensionID )
      widget.id = widget_id.replace("zStock_", "");

    widget.path = "chrome-extension://"+obj.id+"/" + obj.path.replace(/\s+/g, '');
    widget.optionsUrl = obj.optionsUrl;
    widget.resize = false;
    widget.type = "iframe";
    widget.poke = obj.poke;
    if (obj.v2 && obj.v2.resize)
      widget.resize = obj.v2.resize;
    widget.v2 = obj.v2;

    // passing new id to multiplaceable widgets
    widget.instance_id = widget.id;
    if (obj.pokeVersion === 3) {
      if (obj.v3.multi_placement === true) {
        widget.instance_id = new_guid();
      }
    }

    widgets[widget.instance_id] = widget;
  } else if (obj.external) {
    widget.path = obj.path
    widget.optionsUrl = obj.optionsUrl;
    widget.resize = false;
    widget.type = "iframe";
    widget.parent_id = widget.id;

    // monkeypatch out the need for pokes, as needed
    // v2
    if ("min_width" in obj && "max_width" in obj && "min_height" in obj && "max_height" in obj) {
      if(obj.min_width < obj.max_width && obj.min_height < obj.max_height) {
        widget.resize = true;
        widget.v2 = {
          "min_width": obj.min_width,
          "max_width": obj.max_width,
          "min_height": obj.min_height,
          "max_height": obj.max_height
        }
      }
    }
    // v3
    widget.instance_id = widget.id;
    if (obj.multi_placement === true)
      widget.instance_id = new_guid();
      widget.id = widget.instance_id;

    widgets[widget.instance_id] = widget;
  }

  storage.set({tiles: widgets}, function () {
    $(window).trigger("antp-widgets")
  });
}

// Updates widgets
function updateWidget(obj) {
  storage.get("tiles", function(storage_data) {
    if ( typeof(obj.id) !== "string" ) return;

    let widgets = storage_data.tiles;
    if ( !widgets[obj.id] ) return;

    if ( obj.top !== undefined )
      widgets[obj.id].where[0] = obj.top;
    if ( obj.left !== undefined )
      widgets[obj.id].where[1] = obj.left;


    if ( obj.height !== undefined ) {
      let height = parseInt(obj.height);
      if ( height >= 1 && height <= 3 ) {
        widgets[obj.id].size[0] = height;
      }
    }
    if (  obj.width !== undefined ) {
      let width = parseInt(obj.width);
      if ( width >= 1 && width <= 3 ) {
        widgets[obj.id].size[1] = width;
      }
    }

    storage.set({"tiles": widgets})
  });
}


/* START :: Tile Search */

  // To prevent tile animation when clicked in search-box
  $(document).on("mousedown", ".shortcut input.search-box, .app input.search-box", function(e) {
    $(this).closest(".app, .shortcut").removeClass("search-not-active");
  });
  $(document).on("mouseup", ".shortcut input.search-box, .app input.search-box", function(e) {
    $(this).closest(".app, .shortcut").addClass("search-not-active");
  });

  $(document).on("mouseenter", ".shortcut, .app", function(e) {
    let tile = $(this);
    let searchBox = tile.find("input.search-box");
    if (searchBox.length > 0)
      searchBox.focus();
  });

  $(document).on("mouseleave", ".shortcut, .app", function(e) {
    let tile = $(this);
    let searchBox = tile.find("input.search-box");
    if (searchBox.length > 0)
      searchBox.blur();
  });

  $(document).on("keydown", ".shortcut input.search-box, .app input.search-box", function(e) {
    let elem = $(this);
    if (e.which === 13) {
      document.location.href = elem.attr('data-search').replace("{input}", encodeURI(elem.val()));
    }
  });

  /* END :: Tile Search */
