/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// START :: Recently Closed Tabs & Tab Manager Widget

const onRemoved = function(tabId, storage_data) {
    // Cleanup old data
    localStorage.removeItem("recently_closed");

    // If RCTM is disabled, clear data and return
    if (storage_data.settings.recently_closed === false) {
        storage.remove("closed_tabs");
        return;
    }

    const {
        open_tabs
    } = storage_data;
    const closed_tabs = storage_data.closed_tabs || [];
    const disableRCTM = (typeof storage_data.settings !== "undefined") && storage_data.settings.disableRCTM ? storage_data.settings.disableRCTM : false;

    const tab = open_tabs.filter(tab => tab.id === tabId)[0];

    if (!tab || (tab.incognito === true) || (tab.title === "") || ((tab.url).indexOf("chrome://") !== -1)) { return; }
    closed_tabs.unshift({
        title: tab.title,
        url: tab.url
    });

    if (closed_tabs.length > 15) { closed_tabs.pop(); }
    storage.set({closed_tabs}, null, true);
    return getAllTabs();
};

var getAllTabs = () => chrome.tabs.getAllInWindow(null, getAllTabs_callback);

var getAllTabs_callback = tabs => storage.set({open_tabs: tabs}, null, true);

chrome.tabs.onRemoved.addListener(tabId => storage.get(["open_tabs", "closed_tabs", "settings"], storage_data => onRemoved(tabId, storage_data)));

chrome.tabs.onMoved.addListener(getAllTabs);
chrome.tabs.onCreated.addListener(getAllTabs);
chrome.tabs.onUpdated.addListener(getAllTabs);
getAllTabs();

// START :: Tab Manager Widget

$(window).bind("storage", function(e) {
    let id;
    if (e.originalEvent.key === "switch_to_tab") {
        if (localStorage.getItem("switch_to_tab") !== -1) {
            id = parseInt(localStorage.getItem("switch_to_tab"));
            chrome.tabs.getSelected(null, function(tab) {
                if (id !== tab.id) { return chrome.tabs.remove(tab.id); }
            });

            chrome.tabs.update(id,
                {active: true});

            localStorage.setItem("switch_to_tab", -1);
        }
    }
    if (e.originalEvent.key === "close_tab") {
        id = parseInt(localStorage.getItem("close_tab"));
        if (localStorage.getItem("close_tab") !== "-1") {
            chrome.tabs.remove(id);
            localStorage.setItem("close_tab", "-1");
        }
    }
    if (e.originalEvent.key === "pin_toggle") {
        id = parseInt(localStorage.getItem("pin_toggle"));
        return storage.get("open_tabs", function(storage_data) {
            if (typeof id === "null") { return; }
            const tabs = storage_data.open_tabs || [];
            const tab = tabs.filter(tab => tab.id === id)[0];
            if (typeof tab === "undefined") {
                console.error("Tab wasn't found");
                return;
            }

            // Invert pin state
            chrome.tabs.update(id,
                {pinned: !tab.pinned});

            return localStorage.removeItem("pin_toggle");
        });
    }
});

// START :: Get Installed Widgets

window.reloadExtensions = function(data) {
    window.extensions = data;
    window.installedWidgets = {};

    return sayHelloToPotentialWidgets();
};

const buildWidgetObject = function(_widget) {
    const {
        extensions
    } = window;
    const widget = {};
    if (!_widget.request || !_widget.sender) {
        console.error("buildWidgetObject:", "Sender missing.");
        return null;
    } else if (!_widget.request.body) {
        console.error("buildWidgetObject:", "Body missing.");
        return null;
    } else if (!_widget.request.body.poke) {
        console.error("buildWidgetObject:", "Poke version not defined.");
        return null;
    }
    widget.pokeVersion = parseInt(_widget.request.body.poke);
    if ((widget.pokeVersion === "NaN") || (widget.pokeVersion < 1) || (widget.pokeVersion > 3)) {
        console.error("buildWidgetObject:", "Invalid poke version.");
        return null;
    } else if (widget.pokeVersion === 1) {
        console.error("buildWidgetObject:", "Support for poke version 1 has been discontinued. Use poke version 3 instead.");
        return null;
    }
    widget.height = parseInt(_widget.request.body.height);
    widget.width = parseInt(_widget.request.body.width);
    if (!widget.width || !widget.height) {
        console.error("buildWidgetObject:", "Width or Height not defined.");
        return null;
    }
    if (widget.height === "NaN") {
        console.error("buildWidgetObject:", "Invalid height.");
        return null;
    } else if (widget.width === "NaN") {
        console.error("buildWidgetObject:", "Invalid width.");
        return null;
    } else if ((widget.height > 3) || (widget.width > 3)) {
        console.error("buildWidgetObject:", "Width or Height too large.");
        return null;
    }
    if (_widget.sender.name) {
        widget.name = _widget.sender.name;
    } else {
        if (typeof _widget.sender.id === "string") {
            widget.name = extensions.filter(ext => ext.id === _widget.sender.id)[0];
        }
        if ((typeof widget.name !== "undefined") && (typeof widget.name.name === "string")) {
            widget.name = widget.name.name;
        } else {
            console.error("buildWidgetObject:", "Widget name undefined.");
            return null;
        }
    }
    widget.id = _widget.sender.id;
    widget.img = "chrome://extension-icon/" + widget.id + "/128/0";

    // Poke v2 Checks
    const obj = _widget.request.body;
    widget.v2 = {};
    if ((widget.pokeVersion >= 2) && (parseInt(obj.v2.min_width) !== "NaN") && (parseInt(obj.v2.max_width) !== "NaN") && (parseInt(obj.v2.min_height) !== "NaN") && (parseInt(obj.v2.max_height) !== "NaN")) {
        widget.v2.min_width = ((parseInt(obj.v2.min_width) < TILE_MIN_WIDTH) ? TILE_MIN_WIDTH : parseInt(obj.v2.min_width));
        widget.v2.min_width = ((parseInt(obj.v2.min_width) > TILE_MAX_WIDTH) ? TILE_MAX_WIDTH : parseInt(obj.v2.min_width));
        widget.v2.max_width = ((parseInt(obj.v2.max_width) < TILE_MIN_WIDTH) ? TILE_MIN_WIDTH : parseInt(obj.v2.max_width));
        widget.v2.max_width = ((parseInt(obj.v2.max_width) > TILE_MAX_WIDTH) ? TILE_MAX_WIDTH : parseInt(obj.v2.max_width));
        widget.v2.min_height = ((parseInt(obj.v2.min_height) < TILE_MIN_HEIGHT) ? TILE_MIN_HEIGHT : parseInt(obj.v2.min_height));
        widget.v2.min_height = ((parseInt(obj.v2.min_height) > TILE_MAX_HEIGHT) ? TILE_MAX_HEIGHT : parseInt(obj.v2.min_height));
        widget.v2.max_height = ((parseInt(obj.v2.max_height) < TILE_MIN_HEIGHT) ? TILE_MIN_HEIGHT : parseInt(obj.v2.max_height));
        widget.v2.max_height = ((parseInt(obj.v2.max_height) > TILE_MAX_HEIGHT) ? TILE_MAX_HEIGHT : parseInt(obj.v2.max_height));
        widget.v2.resize = obj.v2.resize;
    } else {
        widget.v2.resize = false;
    }
    if (widget.pokeVersion === 3) {
        if (typeof _widget.request.body.v3 === "undefined") {
            console.error("buildWidgetObject:", "v3 property is missing. v3 property is required in poke version 3.");
            return;
        } else if (typeof _widget.request.body.v3.multi_placement === "undefined") {
            console.error("buildWidgetObject:", "v3.multi_placement property is missing. v3.multi_placement property is required in poke version 3.");
            return;
        }
        widget.v3 = _widget.request.body.v3;
    } else {
        widget.v3 = {};
        widget.v3.multi_placement = false;
    }
    const ext = extensions.filter(ext => ext.id === widget.id)[0];
    widget.path = _widget.request.body.path;
    widget.optionsUrl = ext.optionsUrl;
    return widget;
};

var TILE_MIN_WIDTH = 1;
var TILE_MAX_WIDTH = 3;
var TILE_MIN_HEIGHT = 1;
var TILE_MAX_HEIGHT = 3;
window.extensions = {};
window.installedWidgets = {};
chrome.management.getAll(reloadExtensions);

// START :: External Communication Stuff

// Attempts to establish a connection to all installed widgets
var sayHelloToPotentialWidgets = function(extensions) {
    ({
        extensions
    } = window);
    return (() => {
        const result = [];
    for (let i in extensions) {
        result.push(chrome.extension.sendMessage(extensions[i].id, "mgmiemnjjchgkmgbeljfocdjjnpjnmcg-poke"));
    }
    return result;
})();
};

// Listens for responses
const onMessageExternal = function(request, sender, sendResponse) {
    if (request.head && (request.head === "mgmiemnjjchgkmgbeljfocdjjnpjnmcg-pokeback")) {
        const widget = buildWidgetObject({
            request,
            sender
        });
        if (widget != null) { return window.installedWidgets[widget.id] = widget; }
    }
};
chrome.extension.onMessageExternal.addListener(onMessageExternal);

// START :: On App/Widget uninstalled

const removeWidgetInstances = function(id) {
    const widgets = JSON.parse(localStorage.widgets);
    for (let i in widgets) {
        if (widgets[i].id === id) { delete widgets[i]; }
    }
    return localStorage.setItem("widgets", JSON.stringify(widgets));
};
chrome.management.onUninstalled.addListener(removeWidgetInstances);
