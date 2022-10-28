/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns (TODO: @diceroll123)
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// Awesome New Tab Page
// Copyright 2011-2013 Awesome HQ, LLC & Michael Hart
// All rights reserved.
// http://antp.co http://awesomehq.com

// Chrome Storage functions
window.storage = {
    // keys = string or array of strings; null for all
    // callback = required
    get(keys, callback) {
        // Convert string (1 key) to array so that settings can be added
        if (typeof keys === "string") {
            keys = [ keys ];
        }

        // Add settings
        if (keys) {
            keys.push("settings");
        }

        return chrome.storage.local.get(keys, function(items) {
            // Process settings and replace
            items.settings_raw = items.settings;
            items.settings = settings.getAll(items.settings);

            if (callback) {
                return callback(items);
            } else {
                return console.debug(items);
            }
        });
    },

    // items = object with key/value pairs to update storage with
    // callback = optional
    set(items, callback) {
        return chrome.storage.local.set(items, callback);
    },

    // keys = string or array of strings; null for all
    // callback = optional
    remove(keys, callback) {
        return chrome.storage.local.remove(keys, callback);
    },

    // callback = optional
    clear(callback) {
        console.log("storage.clear");
        return chrome.storage.local.clear(callback);
    }
};

chrome.management.getAll(data => window.extensions = data);

// START :: Settings
const DEFAULTS = {
  lock: true,
  buttons: true,
  grid: false,
  recently_closed: true,
  hscroll: false,
  grid_height: null,
  grid_width: null
};

window.settings = {
    // obj = object of keys and what to set them to
    // callback = optional
    set(obj, callback) {
        return storage.get("settings", function(callback_data) {
            const storedSettings = callback_data.settings;
            for (let key in obj) {
                // If key isn't in in DEFAULTS, don't save it
                if (typeof DEFAULTS[key] === "undefined") {
                    if (callback) { callback(false); } else { return; }
                }
                if (obj[key] === DEFAULTS[key]) {
                    delete storedSettings[key];
                } else {
                    storedSettings[key] = obj[key];
                }
            }

            return storage.set({settings: storedSettings}, callback);
        });
    },

    reset() {
        return storage.remove("settings");
    },

    getAll(storedSettings) {
        const userSettings = {};
        if (!storedSettings) {
            storedSettings = {};
        }
        for (let key in DEFAULTS) {
            if (typeof storedSettings[key] !== "undefined") {
                userSettings[key] = storedSettings[key];
            } else {
                userSettings[key] = DEFAULTS[key];
            }
        }
        return userSettings;
    }
};
