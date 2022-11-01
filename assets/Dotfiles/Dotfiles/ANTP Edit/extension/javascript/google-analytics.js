/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
window.ga = window.ga || function() {
    (ga.q = ga.q || []).push(arguments);
};
ga.l = +new Date;

const GA_ID = "UA-26076327-1";

ga("create", GA_ID, "auto");
ga("set", "checkProtocolTask", null); // Disables file protocol checking
ga("send", "pageview");

// Send ANTP version
ga("send", "event", "Version", chrome.app.getDetails().version);


