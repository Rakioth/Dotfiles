/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

const ajs = angular.module('antp', []);

ajs.config([
  "$compileProvider", "$sceProvider",
  function ($compileProvider, $sceProvider) {
    $sceProvider.enabled(false);
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|chrome-extension|chrome):/);
    $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|ftp|file|chrome-extension|chrome):|data:image\//);
  }
]);


/* START :: Widget API interface */

  ajs.directive('antpWidget', ['$window', function(window) {
    return {
      restrict: 'E',
      scope: {
        widget: '=',
        widgetData: '='
      },
      template: `<iframe ng-src="{{ widget.path + (widget.path.startsWith(\'chrome-extension://\') ? widget.hash : \'\') }}" scrolling="no" frameborder="0" align="center" height="100%" width="100%"></iframe>
        <div class="iframe-mask" ng-hide="configuring">
          <div id="delete" class="sprite"></div>
          <div id="widget-config" class="sprite" ng-show="widget.optionsUrl" ng-mouseup="widget.onConfigure();"></div>
          <div class="resize-tile">
            <div class="resize-tile-top" ng-show="widget.resize"></div>
            <div class="resize-tile-bottom" ng-show="widget.resize"></div>
            <div class="resize-tile-left" ng-show="widget.resize"></div>
            <div class="resize-tile-right" ng-show="widget.resize"></div>
          </div>
        </div>`,
      link: function(scope, element, attrs) {
        let widget = scope.widget;
        scope.configuring = false;

        let isExternal = widget.parent_id !== undefined;
        if (!isExternal) {
          widget.onConfigure = () => {
            location.href = widget.optionsUrl + (widget.path.startsWith('chrome-extension://') ? widget.hash : '');
          };
          return;
        }

        const matches = (widget.path).match(/(^.*?):\/\/[^\/]*/i)
        if (matches === null) {
          return
        }
        origin = matches[0];
        let iframe = element.children()[0];

        const connection = window.Penpal.connectToChild({
          iframe,
          childOrigin: origin,
          // debug: true,
          methods: {
            getData() {
              return JSON.parse(scope.widgetData || '{}');
            },
            setData(data) {
              data = JSON.stringify(data || {})
              window.storage.get('widgetData', (storage_data) => {
                storage_data.widgetData = storage_data.widgetData || {};
                storage_data.widgetData[widget.instance_id] = data;
                scope.widgetData = data;
                scope.$apply();
                window.storage.set({widgetData: storage_data.widgetData});
              });
            },
            enableConfigure() {
              scope.$apply(function () {
                widget.onConfigure = () => {
                  connection.promise.then((child) => {
                    scope.$apply(function () {
                      scope.configuring = true;
                    });
                    child.getConfigureFunction();
                  });
                };
              });
            },
            exitConfigure() {
              scope.$apply(function () {
                scope.configuring = false;
              });
            }
          }
        });


      }
    }
  }])

  /* END :: Widget API interface */

/* START :: Widgets/Shortcuts/Custom Shortcuts */

  ajs.controller("tileCtrl", ["$scope", "$http", function($scope, $http) {

    $scope.widgets = [];
    $scope.widgetData = {};
    $scope.apps = {};
    $scope.custom_shortcuts = {};

    $scope.update = async function(storage_data) {
      let tiles = storage_data.tiles;
      $scope.widgetData = storage_data.widgetData || {};
      let settings = storage_data.settings || {};

      // Load previous settings or
      if (!tiles) {
        if (localStorage.getItem("widgets")) {
          tiles = JSON.parse(localStorage.getItem("widgets") || localStorage.getItem("old_widgets"))
        } else {
          let defaults = await $http({
            method: 'GET',
            // `&setDefaults=true` when used specifically for initial load / reset
            url: `https://api.antp.co/defaults/v1/antp?setDefaults=true`
          }).then(async function (response) {
            return response.data.tiles;
          });

          // ensure all 'iframes' have a unique instance_id
          for (const [key, value] of Object.entries(defaults)) {
            if (value.type === 'iframe') {
              defaults[key].instance_id = new_guid();
            }
          }

          tiles = angular.copy(defaults);
        }

        storage.set({
          tiles: tiles
        }, function() {
          $(window).trigger("antp-widgets")
        });

        return;
      }

      let needsMigration = false;

      // TODO: Remove this sometime after Dec 2020
      // Delete sphere
      if (tiles.sphere1x2) {
        delete tiles.sphere1x2;
        needsMigration = true;
      }
      if (tiles.sphere3x1) {
        delete tiles.sphere3x1;
        needsMigration = true;
      }

      // Migrate clock widget to CDN
      if (tiles.clock && tiles.clock.path) {
        tiles.clock.path = 'https://static.antp.co/widgets/clock/widget.clock.html';
        needsMigration = true;
      }

      // Migrate Google widget to CDN
      if (tiles.google && tiles.google.path) {
        tiles.google.path = 'https://static.antp.co/widgets/google/widget.google.html';
        needsMigration = true;
      }

      // Migrate Facebook from png -> svg
      if (tiles.facebook && tiles.facebook.img) {
        tiles.facebook.img = 'https://static.antp.co/shortcuts/facebook.com.svg';
        needsMigration = true;
      }

      // Migrate Twitter from png -> svg
      if (tiles.twitter && tiles.twitter.img) {
        tiles.twitter.img = 'https://static.antp.co/shortcuts/twitter.com.svg';
        needsMigration = true;
      }

      // Migrate tutorial widget from pre-angular
      if (tiles.tutorial) {
        tiles.tutorial.path = '/extension/widgets/tutorial/widget.tutorial.html';
        needsMigration = true;
      }

      // Remove CWS tile
      if (tiles.webstore) {
        delete tiles.webstore;
        needsMigration = true;
      }

      // Fix weather widget
      if (tiles.undefined && tiles.undefined.type === 'iframe') {
        const newGuid = new_guid();

        tiles[newGuid] = tiles.undefined;
        delete tiles[newGuid];

        if ($scope.widgetData.undefined) {
          $scope.widgetData[newGuid] = $scope.widgetData.undefined;
          delete $scope.widgetData.undefined;
        }
        needsMigration = true;
      }

      // Migrate xkcd from AHQ one to ANTP
      if (tiles['fc7c10e9-77f9-4da2-9d64-45448963c9a1'] && tiles['fc7c10e9-77f9-4da2-9d64-45448963c9a1'].v2 === undefined) {
        tiles['fc7c10e9-77f9-4da2-9d64-45448963c9a1'].path = 'https://static.antp.co/widgets/xkcd/index.html';
        tiles['fc7c10e9-77f9-4da2-9d64-45448963c9a1'].resize = true;

        tiles['fc7c10e9-77f9-4da2-9d64-45448963c9a1'].v2 = {
          min_width: 1,
          max_width: 2,
          min_height: 1,
          max_height: 2,
        };

        needsMigration = true;
      }

      // Migrate the star image, if needed...
      for (let key in tiles) {
        if (tiles[key].img === 'core.shortcut.blank2.png') {
          tiles[key].img = 'https://static.antp.co/shortcuts/new_shortcut_star.svg'
          needsMigration = true;
        }
      }

      if (needsMigration) {
        storage.set({"tiles": tiles, "widgetData": $scope.widgetData});
      }

      $scope.widgets = [];
      $scope.apps = {};
      $scope.custom_shortcuts = {};

      let firstLoad = true;
      angular.forEach(tiles, function(tile, id) {
        if ( tile.isApp === true )
          tile.type = "app";

        if ( tile.appLaunchUrl && tile.appLaunchUrl === "http://www.amazon.com/?tag=sntp-20" ) {
          return true;
        }


        tile.ext = tile.id = id;

        if ( tiles[tile.id].optionsUrl ) {
          tile.optionsUrl = tiles[tile.id].optionsUrl;
        }

        /* Start :: CSS */

          tile.css = {};
          tile.css.height = ( tile.size[0] * GRID_TILE_SIZE ) + ( ( tile.size[0] - 1 ) * ( GRID_TILE_PADDING * 2 ) );
          tile.css.width  = ( tile.size[1] * GRID_TILE_SIZE ) + ( ( tile.size[1] - 1 ) * ( GRID_TILE_PADDING * 2 ) );
          tile.css.top    = tile.where[0] * ( GRID_TILE_SIZE + ( GRID_TILE_PADDING * 2 ) ) + ( GRID_TILE_PADDING * 2 );
          tile.css.left   = tile.where[1] * ( GRID_TILE_SIZE + ( GRID_TILE_PADDING * 2 ) ) + ( GRID_TILE_PADDING * 2 );

          if ( parseInt(settings.grid_height) % 1 === 0 ) {
            if ( (parseInt(tile.where[0]) + parseInt(tile.size[0])) > parseInt(settings.grid_height) )
              return;
          }

          if ( parseInt(settings.grid_width) % 1 === 0 ) {
            if ( (parseInt(tile.where[1]) + parseInt(tile.size[1])) > parseInt(settings.grid_width) )
              return;
          }

          if ( tile.type === "app" || tile.type === "shortcut" ) {
            if (tile.shortcut_background_transparent === true) {
              tile.css.bg = "background-image: url(" + tile.img + "); background-color: transparent;";
            } else {
              tile.css.bg = `background-image: url(${tile.img})${window.gradient}; background-color: ${tile.color};`;
            }
          }

          if ( tile.img && (tile.type === "app" || tile.type === "shortcut") ) {
            tile.css.bgimg = "background-image: url("+tile.img+")";
          }

          /* END :: CSS */

        // Defaults
        if ( tile.favicon_show === undefined ) {
          tile.favicon_show = true;
        }
        if ( tile.name_show === undefined ) {
          tile.name_show = true;
        }

        // Fixed list app urls with  their search urls
        const fixedSearchURLs = {
          "http://www.youtube.com/": "http://www.youtube.com/results?search_query={input}",
          "http://www.facebook.com/": "http://www.facebook.com/search/?q={input}",
          "http://www.twitter.com/": "http://twitter.com/search?q={input}&src=typd",
          "http://www.google.com/webhp?source=search_app": "http://www.google.com/search?source=search_app&q={input}",
          "https://chrome.google.com/webstore?utm_source=webstore-app&utm_medium=awesome-new-tab-page": "https://chrome.google.com/webstore/search/{input}"
        };

        switch ( tile.type ) {
          case "iframe":
            tile.hash = "";
            if ( tile.instance_id ) {
              tile.hash = "#" + encodeURIComponent(JSON.stringify({id: tile.instance_id}));
            }
            if (firstLoad) {
              const eventWidgetIdString = `${tile.name} ${ (tile.parent_id || "n/a") }${tile.path ? ' ' + tile.path : ''}`;
              // console.log("Load Widget -", eventWidgetIdString, tile)
              ga("send", "event", "widget-iframe", eventWidgetIdString);
            }
            $scope.widgets.push(tile);
            break;
          case "app":
            tile.resize = true;
            if (fixedSearchURLs[tile.appLaunchUrl]) {
              tile.searchUrl = fixedSearchURLs[tile.appLaunchUrl];
              tile.searchEnabled = true;
            }

            $scope.apps[tile.id] = tile;
            break;
          case "shortcut":
            tile.resize = true;
            if (tile.searchUrl && tile.searchUrl.includes("{input}")) {
              tile.searchEnabled = true;
            }
            $scope.custom_shortcuts[id] = tile;
            break;
        }
      });
      firstLoad = false;

      setTimeout(function(){
        $("#grid-holder > .tile").addClass("empty");
        $("#widget-holder > div").each(function(ind, elem){
          const tiles = getCovered(this);
          $(tiles.tiles).each(function(ind, elem){
            $(elem).removeClass("empty");
          });
        });
      }, 250);


      $scope.$apply();
    }; // End of $scope.update()

    storage.get(["tiles", "widgetData"], $scope.update);

    // May be necessary since onChanged runs on-same-page, which could be bad for rapid-firing
    // events, like changing tile or background colors
    $(window).bind("antp-widgets", function () {
      storage.get(["tiles", "widgetData"], $scope.update);
    });
  }])

/* END :: Widgets/Shortcuts/Custom Shortcuts */

/* START :: Shortcuts/Widgets Window */

  ajs.controller("windowAppsWidgetsCtrl", ["$scope", "$http", function($scope, $http) {

    $scope.stock_apps = {};
    $scope.stock_widgets = {};

    $scope.apps = {};
    $scope.widgets = {};
    $scope.external_widgets = {};

    let timeoutId = null;

    function getExternalWidgets() {
      if (Object.keys($scope.external_widgets).length !== 0) {
        // cache until next reload
        return;
      }

      let external_widgets = [];
      $http({
        method: 'GET',
        url: `https://api.antp.co/widgets?extensionVersion=${chrome.app.getDetails().version}`
      }).then(function (response) {
        $.each(response.data, function (index, widget) {
          widget.id = widget.uuid;
          widget.external = true;
          external_widgets[widget.uuid] = widget;
        })
        $scope.external_widgets = external_widgets;
      })
    }

    $scope.update = function() {
      clearTimeout(timeoutId);  // to prevent multiple running of $scope.update function

      getExternalWidgets();

      // Refresh widgets
      chrome.runtime.getBackgroundPage(function (bp) {
        chrome.management.getAll(bp.reloadExtensions);

        // Refresh apps
        chrome.management.getAll(function (all) {
          $scope.apps = {};
          angular.forEach(all, function (extension, id) {
            if (extension.isApp === true && extension.enabled === true) {
              extension.img = "chrome://extension-icon/" + extension.id + "/128/0";
              $scope.apps[extension.id] = extension;
            }
          });
        });

        // monkeypatch installedWidgets to distinguish from the others
        let installedWidgets = bp.installedWidgets;
        for (const key of Object.keys(installedWidgets)) {
          installedWidgets[key].installed = true;
        }

        setTimeout(function() {
          $scope.apps = {...$scope.apps, ...$scope.stock_apps};
          $scope.apps_sorted = Object.keys($scope.apps).sort(function(a, b){
            let nameA=$scope.apps[a].name.toLowerCase(), nameB=$scope.apps[b].name.toLowerCase();
            if (nameA < nameB)
              return -1;
            if (nameA > nameB)
              return 1;
            return 0
          });

          $scope.widgets = {...installedWidgets, ...$scope.external_widgets};

          // Update every 30 seconds
          timeoutId = setTimeout($scope.update, 30000);

          $scope.$apply();
          disableUrls();

        }, 1000);
      });
    };

    $(document).on("click", "#app-drawer-button,#widget-drawer-button,#unlock-button", function() {
      timeoutId = setTimeout($scope.update, 1);
    });

    $scope.updateBuffer = function() {
      clearTimeout(timeoutId);
      timeoutId = setTimeout($scope.update, 1000);
    };

    chrome.management.onEnabled.addListener( $scope.updateBuffer );
    chrome.management.onInstalled.addListener( $scope.updateBuffer );
    chrome.management.onDisabled.addListener( $scope.updateBuffer );
    chrome.management.onUninstalled.addListener( $scope.updateBuffer );

    // Save $scope.stock_apps
    setTimeout(async function() {
      let stockWidgets = {};
      let defaultTiles = await $http({
        method: 'GET',
        url: `https://api.antp.co/defaults/v1/antp`
      }).then(async function (response) {
        return response.data.tiles;
      });
      angular.forEach(defaultTiles, function(widget, id) {
        if ( widget.isApp === true
          && widget.type === "app" ) {
          widget.mayDisable = false;
          $scope.stock_apps[widget.id] = widget;
        }
      });
    }, 900);

  }]);

  /* END :: Apps/Widgets Window */

/* START :: Tile Editor */

  ajs.controller("windowTileEditorCtrl", ["$scope", "$http", function($scope, $http) {

    $scope.safeApply = function(fn) {
      const phase = this.$root.$$phase;
      if(phase === '$apply' || phase === '$digest') {
        if(fn && (typeof(fn) === 'function')) {
          fn();
        }
      } else {
        this.$apply(fn);
      }
    };

    $scope.widgets = {};

    $scope.update = function (a, b) {
      // save all the things, put all the things into the tile.
      const id = $(".ui-2#editor").attr("active-edit-id");
      $scope[a] = $scope.widgets[id][a] = b;

      if (a == "shortcut_pin" && b == true)
        $scope.shortcut_newtab = false;
      if (a == "shortcut_newtab" && b == true)
        $scope.shortcut_pin = false;

      switch (a) {
        case "appLaunchUrl":
          $scope.favicon = "chrome://favicon/" + $scope.widgets[id].appLaunchUrl;
          $scope.widgets[id].url = $scope.widgets[id].appLaunchUrl;
          $("#widget-holder #"+id+" a").attr("data-url", $scope.appLaunchUrl).attr("href", $scope.appLaunchUrl);
          $("#widget-holder #"+id+" .app-favicon").attr("src", $scope.favicon);
          break;
        case "shortcut_pin": case "shortcut_newtab":
          $scope.widgets[id].onleftclick = "";
          if ( $scope.shortcut_pin === true ) {
            $scope.widgets[id].onleftclick = "pin";
          }
          if ( $scope.shortcut_newtab === true ) {
            $scope.widgets[id].onleftclick = "newtab";
          }
          $scope.onleftclick = $scope.widgets[id].onleftclick;
          $("#widget-holder #"+id+" .url").attr("onleftclick", $scope.widgets[id].onleftclick);
          break;
        case "searchUrl":
          $scope.widgets[id].searchEnabled = ($scope.shortcut_search_url !== "");
          $("#widget-holder #"+id+" .search-box").attr("data-search", $scope.shortcut_search_url);
          break;
        case "shortcut_background_transparent":
        case "backgroundimage":
        case "backgroundcolor":
        case "img":
          if ($scope.shortcut_background_transparent === true) {
            $scope.backgroundimage = "url("+$scope.widgets[id].img+")";
            $scope.backgroundcolor = "transparent";
            $scope.widgets[id].shortcut_background_transparent = true;
          } else {
            $scope.backgroundimage = "url("+$scope.widgets[id].img+")" + gradient;
            $scope.widgets[id].color = $scope.color;
            $scope.backgroundcolor = $scope.widgets[id].color;
            $scope.widgets[id].shortcut_background_transparent = false;
          }
          $(".ui-2#editor #invisible-tile-img").attr("src", $scope.widgets[id].img);
          $("#widget-holder #"+id + ", #preview-tile").css("background-image", $scope.backgroundimage).css("background-color", $scope.backgroundcolor);
          IconResizing.previewTileUpdated();
          break;
        case "name":
        case "name_show":
          $("#widget-holder #"+id+" .app-name").html($scope.name).css("opacity", +$scope.name_show);
          break;
        case "favicon_show":
          $("#widget-holder #"+id+" .app-favicon").css("opacity", +$scope.favicon_show);
          break;
      }

      storage.set({tiles: $scope.widgets});
      $scope.safeApply();
    };

    $scope.edit = async function(id, storage_data) {

      const widgets = storage_data.tiles;
      $scope.widgets = storage_data.tiles;

      const tile = widgets[id];

      const this_extension = extensions.filter(function (ext) {
        return ext.id === id
      })[0];
      const is_app = (typeof (this_extension) !== "undefined" && typeof (this_extension.isApp) === "boolean");
      const is_shortcut = (tile.type && tile.type === "shortcut");


      let editor_type;
      if ( is_shortcut ) {
        editor_type = "shortcut";
        $(".ui-2#editor").addClass("type-shortcut").removeClass("type-app");
      } else {
        editor_type = "app";
        $(".ui-2#editor").addClass("type-app").removeClass("type-shortcut");
      }

      $("body > .ui-2").hide();

      $(".ui-2#editor")
        .show()
        .attr("active-edit-id", id)
        .attr("active-edit-type", editor_type);

      let stock_app = false;
      if ( $.inArray(id, ["webstore", "facebook", "twitter"]) !== -1 ) {
        let defaults = await $http({
          method: 'GET',
          url: `https://api.antp.co/defaults/v1/antp`
        }).then(async function (response) {
          return response.data.tiles;
        });
        tile.img = defaults[id].img;
        stock_app = true;
      }

      if ( is_shortcut ) {
        $scope.favicon = "chrome://favicon/" + tile.appLaunchUrl;
        $scope.favicon_show = tile.favicon_show !== false;
        $scope.searchUrl = tile.searchUrl;
      } else {
        $scope.searchUrl = "";
        $scope.favicon_show = false;
      }

      if ( tile.name_show === undefined ) {
        tile.name_show = true;
      }

      $scope.name = tile.name;
      $scope.name_show = tile.name_show;
      $scope.shortcut_pin = (tile.onleftclick === "pin");
      $scope.shortcut_newtab = (tile.onleftclick === "newtab");
      $scope.onleftclick = tile.onleftclick;
      $scope.url = tile.appLaunchUrl;
      $scope.appLaunchUrl = tile.appLaunchUrl;
      $scope.searchUrl = tile.searchUrl;
      $scope.shortcut_background_transparent = tile.shortcut_background_transparent;
      $scope.img = tile.img;
      $scope.color = tile.color; // to preserve the actual color
      $scope.backgroundcolor = tile.color; // to hold color/transparent

      if($scope.shortcut_background_transparent === true) {
        $scope.backgroundimage = "url("+tile.img+")";
        $scope.backgroundcolor = "transparent";
      } else {
        $scope.backgroundimage = "url(" + tile.img + ")" + window.gradient;
        $scope.backgroundcolor = tile.color;
        $scope.color = tile.color;
      }

      $scope.safeApply();

      requiredColorPicker(function() {
        let rgb = [];
        rgb = (widgets[$(".ui-2#editor").attr("active-edit-id")].color).match(/(rgba?)|(\d+(\.\d+)?%?)|(\.\d+)/g);

        $(".ui-2#editor #shortcut_colorpicker").ColorPicker({
          color: ( ({ r: rgb[1], g: rgb[2], b: rgb[3] }) || "#309492") ,
          onShow: function (colpkr) {
            $(colpkr).fadeIn(500);
            rgb = (widgets[$(".ui-2#editor").attr("active-edit-id")].color).match(/(rgba?)|(\d+(\.\d+)?%?)|(\.\d+)/g);
            return false;
          },
          onHide: function (colpkr) {
            $(colpkr).fadeOut(500);
            return false;
          },
          onChange: function (hsb, hex, rgb) {
            $scope.backgroundcolor = "rgba("+rgb.r+","+rgb.g+","+rgb.b+", 1)";
            $scope.shortcut_background_transparent = false;
            $scope.color = $scope.backgroundcolor;
            $scope.update("backgroundcolor", $scope.color);
          }
        });
        $(".ui-2#editor #shortcut_colorpicker").ColorPickerSetColor( ({ r: rgb[1], g: rgb[2], b: rgb[3] }) );
      });

      $("#swatches").html("").hide();
      if ( is_app === true && stock_app === false ) {
        const image = tile.img,
            medianPalette = createPalette(
                $("<img />").attr({
                  "src": image,
                  "id": "temporary-element-to-delete"
                }).css({
                  "display": "none"
                }).appendTo("body")
                , 5);
        $.each(medianPalette, function(index, value) {
          let swatchEl = $('<div>')
              .css("background-color", "rgba(" + value[0] + "," + value[1] + "," + value[2] + ", 1)")
              .data({
                "r": value[0],
                "g": value[1],
                "b": value[2]
              }).addClass("swatch");
          $("#swatches").append(swatchEl).show();
        });

        $("#temporary-element-to-delete").remove();
      }
      $(".ui-2#editor #invisible-tile-img").attr("src", tile.img);
      if (tile.backgroundSize) {
        $("#widget-holder #"+id + ", #preview-tile").css("background-size", tile.backgroundSize);
        IconResizing.previewTileUpdated(IconResizing.updateSlider);
      }
      IconResizing.previewTileUpdated();
    };

    $(document).on("click", "#shortcut-edit", function() {
      let id = $(this).parent().parent().parent().attr("id");
      storage.get("tiles", function(storage_data) {
        $scope.edit(id, storage_data);
      });
    });
  }]);

  ajs.directive('ngTileEditor', function() {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function($scope, elm, attr, ngModelCtrl) {

        let bind_method;
        if (attr.type === 'radio' || attr.type === 'checkbox') {
          bind_method = "click";
        } else {
          bind_method = "change keyup keydown keypress";
        }
        elm.bind(bind_method, function(event) {
          let value = elm.val();
          $scope.$apply(function() {
            // i have to set up special cases, because some checkboxes use values AND checked booleans
            // if checked, use value.
            if (attr.name === "shortcut_pin" || attr.name === "shortcut_newtab") {
              value = $("#" + attr.name).is(':checked');

              // uncheck the other box (if checked)
              $("#" + (attr.name === "shortcut_pin" ? "shortcut_newtab" : "shortcut_pin")).removeAttr("checked");
            }

            // checked = true, unchecked = false
            // rather than unchecked = undefined
            if (attr.name === "name_show" || attr.name === "favicon_show" || attr.name === "shortcut_background_transparent") {
              value = $("#" + attr.name).is(':checked');
            }

            ngModelCtrl.$setViewValue(value);
          });
          if ($scope.update) {
            $scope.update(attr.ngModel.split(".")[2], value);
          } else {
            $scope.$parent.update(attr.ngModel.split(".")[2], value);
          }
        });
      }
    };
  });

  /* END :: Tile Editor */

/* START :: Tabs & Panes Directives */

  ajs.directive('tabs', function() {
    return {
      restrict: 'E',
      transclude: true,
      scope: {},
      controller: function($scope, $element) {
        const panes = $scope.panes = [];

        $scope.select = function(pane) {
          angular.forEach(panes, function(pane) {
            pane.selected = false;
          });
          pane.selected = true;

          if(pane.selected === true && pane.name === "Background") {
            $("#icon-resize-scale-controls").show();
          } else {
            $("#icon-resize-scale-controls").hide();
          }
        }

        this.addPane = function(pane) {
          if (panes.length === 0) $scope.select(pane);
          panes.push(pane);
        }
      },
      template:
        '<div class="tabbable">' +
          '<ul class="nav nav-tabs">' +
            '<li ng-repeat="pane in panes" class="{{pane.class}}" ng-class="{active:pane.selected}">'+
              '<a href="" ng-click="select(pane)">{{pane.name}}</a>' +
            '</li>' +
          '</ul>' +
          '<div class="tab-content" ng-transclude></div>' +
        '</div>',
      replace: true
    };
  }).
  directive('pane', function() {
    return {
      require: '^tabs',
      restrict: 'E',
      transclude: true,
      scope: { name: '@', class: '@' },
      link: function(scope, element, attrs, tabsCtrl) {
        tabsCtrl.addPane(scope);
      },
      template:
        '<div class="tab-pane" ng-class="{active: selected}" ng-transclude>' +
        '</div>',
      replace: true
    };
  });

  /* END :: Tabs & Panes Directives */

/* START :: Checkbox Directive */

  ajs.directive('onoff', function() {
    return {
      restrict: 'E',
      transclude: true,
      scope: { name: '@', state: '=', onChange: '&' },
      require: 'state',
      template:
        '<div>' +
          '<div class="onoffswitch">' +
            '<input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="{{name}}" ng-model="state" ng-change="onChange({checked:state})">' +
            '<label class="onoffswitch-label" for="{{name}}">' +
              '<div class="onoffswitch-inner">' +
                '<div class="onoffswitch-active"><div class="onoffswitch-switch">ON</div></div>' +
                '<div class="onoffswitch-inactive"><div class="onoffswitch-switch">OFF</div></div>' +
              '</div>' +
            '</label>' +
          '</div>' +
        '</div>',
      replace: true
    };
  });

  /* END :: Checkbox Directive */
