/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Awesome New Tab Page
// Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
// All rights reserved.
// http://antp.co http://awesomehq.com


// Utility functions
window.util = {};
window.util.toArray = list => Array.prototype.slice.call(list || [], 0);

window.palette = [
    "rgba(51,   153,  51,    1)",
    "rgba(229,  20,   0,     1)",
    "rgba(27,   161,  226,   1)",
    "rgba(240,  150,  9,     1)",
    "rgba(230,  113,  184,   1)",
    "rgba(153,  102,  0,     1)",
    "rgba(139,  207,  38,    1)",
    "rgba(255,  0,    151,   1)",
    "rgba(162,  0,    225,   1)",
    "rgba(0,    171,  169,   1)"
];

window.gradient = ", -webkit-gradient(linear, 100% 0%, 0% 100%, to(rgba(255, 255, 255, 0.05)), from(rgba(255, 255, 255, 0.10)))";

// display messages to be displayed on page refresh
if (localStorage.msg) {
    const msg = JSON.parse(localStorage.msg);
    setTimeout((() => $.jGrowl(msg.message,
        {header: msg.title})), 500);
    localStorage.removeItem("msg");
}

// Reload page
window.reload = () => window.location.reload(true);

// Generate a GUID-style string
window.new_guid = function() {
    const S4 = () => (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    return S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4();
};


// START :: URL Handler
let url_handler = false;
$(document).on("mousedown", ".url", function(e) {
    const url = $(this).attr("data-url");
    if (url && (typeof (url) === "string") && (url !== "")) {
        url_handler = url;
    } else {
        url_handler = false;
    }
    $(this).attr("href", url);
    if ((e.which === 2) || ((e.ctrlKey === true) && (e.which !== 3))) { return $(this).attr("href", null); }
});

$(document).on("mouseup", document, e => url_handler = false);

$(document).on("mouseup", ".url", function(e) {

    // Ctrl + Click = Open in new tab
    if (e.which !== 3) {
        if (e.ctrlKey === true) { e.which = 2; }
        if (e.metaKey === true) { e.which = 3; }
    }
    const url = $(this).attr("data-url");
    if (url && (typeof (url) === "string") && (url !== "") && url_handler && (url_handler === url)) {
        if (e.shiftKey !== true) {
            if (e.which === 1) {
                if ($(this).attr("ng-onleftclick") === "pin") {
                    chrome.tabs.getCurrent(tab => chrome.tabs.update(tab.id, {
                        url: String(url),
                        pinned: true
                    }));

                } else if ($(this).attr("ng-onleftclick") === "newtab") {
                    $(this).attr("href", "#");
                    chrome.tabs.create({
                        url,
                        active: false
                    });

                } else if (url.match(/^(http:|https:)/)) {
                    window.location = url;
                } else {
                    // Left click, open a new one and close the current one
                    chrome.tabs.getCurrent(tab => chrome.tabs.update(tab.id, {
                        url: String(url),
                        active: true
                    }));
                }

            } else if (e.which === 2) {
                chrome.tabs.create({
                    url,
                    active: false
                });
            }
        }

    } else if ((!url || (url === "")) && (($(this).closest(".app").attr("type") === "app") || ($(this).closest(".app").attr("type") === "packaged_app"))) {
        if ((e.which === 1) || (e.which === 2)) {
            const app = $(this).closest(".app");
            if (app.length > 0) { chrome.management.launchApp(app.attr("id")); }
            if (e.which === 1) {
                chrome.tabs.getCurrent(tab => chrome.tabs.remove([tab.id]));
            }
        }
    }

    $(this).delay(100).queue(function() {
        return $(this).attr("href", url);
    });

    return url_handler = false;
});

// END :: URL Handler

// Delete tile
window.removeWidget = widget => storage.get(["tiles", "widgetData"], function(storage_data) {
    const widgets = storage_data.tiles;
    delete widgets[widget];

    const widgetData = storage_data.widgetData;
    if(widget.instance_id) {
        delete widgetData[widget.instance_id];
    }

    return storage.set({tiles: widgets, widgetData: widgetData});
});








