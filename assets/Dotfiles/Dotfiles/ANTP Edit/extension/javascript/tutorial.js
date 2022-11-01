/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

function startTutorial() {
  var next = "<a href='#' class='tutorial-next bubble'>Next</a>";
  var steps = [
    { target: $("#app-drawer-button"), title: "Apps Window", content: "Here you'll find all of the apps that you've installed from the Chrome Web Store. You can <b>drag</b> apps out of this window onto your <b>unlocked</b> grid. You can also uninstall apps from this window." + next },
    { target: $("#widget-drawer-button"), title: "Widgets Window", content: "Here you'll find installed widgets made by third-party developers specifically designed for Awesome New Tab Page. Widgets bring dynamic and useful information right to your new tab page." + next },
    { target: $("#unlock-button"), title: "Lock/Unlock Grid", content: "Locking and unlocking the grid allows you to place, move, and remove widgets, apps, and custom shortcuts. <b>Click the padlock to continue</b>." },
    { target: $("#tutorial #delete"), title: "Delete this widget", content: "The grid is yours to customize as you see fit. You can remove tiles you don't want. Go ahead and <b>delete the tutorial widget</b>." },
    { target: $(".tile#1x0"), title: "Empty Grid Tile", content: "Why be limited to apps found on the Chrome Web Store? <b>Click on this empty grid tile</b> to create a custom shortcut to anywhere on the web." }
  ];

  $(document.body).qtip({
    id: "tutorial-tip",
    content: {
      text: steps[0].content,
      title: {
        text: "<b>" + steps[0].title + "</b>",
        button: true
      }
    },
    position: {
      my: "left center",
      at: "right center",
      target: steps[0].target,
      viewport: $(window)
    },
    show: {
      event: false,
      ready: true
    },
    style: {
      classes: "qtip-light qtip-bootstrap qtip-shadow"
    },
    hide: false,
    events: {
      render: function(event, api) {
        var tooltip = api.elements.tooltip;
        api.step = 0;

        $(document).unbind("tutorial-next").bind('tutorial-next', function(event) {
          api.step++;
          var current = steps[api.step];
          if (current) {
            api.set('content.text', current.content);
            api.set('content.title', "<b>" + current.title + "</b>");
            api.set('position.target', current.target);
          }

          if ( current === undefined ) {
            api.destroy();
            qTipAlert("You're awesome!",
              "Like, really awesome. Now you know how to use Awesome New Tab Page to get the most out of your Chrome experience. So what are you going to do next?",
              "Finish Tutorial");
          }

          switch(api.step) {
            case 2:
              api.set('position.target', current.target.addClass("tutorial-next"));
              break;
            case 3:
              $("#unlock-button").removeClass("tutorial-next");
              setTimeout(function(){
                api.set('position.target', current.target.show().addClass("tutorial-next"));
              }, 0);
              break;
            case 4:
              $(".tile#0x0").removeClass("tutorial-next");
              api.set('position.target', current.target.addClass("tutorial-next"));
              break;
          }
        });
      },
      hide: function(event, api) { api.destroy(); }
    }
  });
}

$(document).on("click", ".tutorial-next", function(event) {
  $(document).trigger("tutorial-next");
});
