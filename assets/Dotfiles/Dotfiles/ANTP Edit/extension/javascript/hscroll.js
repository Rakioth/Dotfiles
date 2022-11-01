/*
  Awesome New Tab Page
  Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
  All rights reserved.
  http://antp.co http://awesomehq.com
*/

/* START :: Horizontal Scrolling */

  var
    hscroll = true,
    hscroll_enabled = true;

  $(document).on({
    mouseleave: function() {
      hscroll = true;
    },
    mouseenter: function() {
      hscroll = false;
    }
  }, ".no-scoll,body > .ui-2,#rsa iframe");

  function scrollHorizontal(event) {
    var delta = 0;

    if ( !hscroll_enabled )
      return;

    if ( !event )
      event = window.event;

    if ( event.originalEvent )
      event = event.originalEvent;

    if ( hscroll === false ) {
      return;
    }

    if ( event.wheelDelta ) {
      delta = event.wheelDelta/120;
    }

    if (delta < 0)
      window.scrollBy(150, 0);
    else if (delta > 0)
      window.scrollBy(-150, 0);

    if ( event.preventDefault )
      event.preventDefault();

    event.returnValue = false;
  }
  $(document).on("mousewheel", scrollHorizontal);

  /* START :: Options Window */

    $(window).bind("antp-config-first-open", function() {
      storage.get("settings", function(storage_data) {
        $("#disableHscroll").prop("checked", storage_data.settings.hscroll);
        $(document).on("change", "#disableHscroll", disableHorizontalScrolling);
      });
    });

    function disableHorizontalScrolling(e) {
      storage.get("settings", function(storage_data) {
        if ( e ) {
          settings.set({"hscroll": $("#disableHscroll").is(":checked")});
          storage_data.settings.hscroll = $("#disableHscroll").is(":checked");
        }

        hscroll_enabled = storage_data.settings.hscroll;
      });
    }

    disableHorizontalScrolling();

    /* END :: Options Window */

  /* END :: Horizontal Scrolling */
