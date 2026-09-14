// ==UserScript==
// @name        no-shorts
// @description Blocks YouTube Shorts and Instagram Reels; the rest of both sites keeps working.
// @match       *://*.youtube.com/*
// @match       *://*.instagram.com/*
// @run-at      document-start
// @noframes
// ==/UserScript==
//
// One file, loaded three ways: as the content script of the force-installed
// Chrome/Brave extension (install.sh), as a qutebrowser greasemonkey script,
// and by node for the tests, which only need isBlocked().
//
// The browser policy's URLBlocklist already stops a full page load of a Short
// or a Reel. It cannot see the rest: both sites are single-page apps that
// change the URL with history.pushState, which is not a navigation as far as
// the blocklist is concerned, so clicking a Short on the YouTube home page
// would sail straight past it. That gap is what this script closes.

(function () {
  'use strict';

  // /shorts/ID, and the Shorts tab of a channel or hashtag page.
  const YOUTUBE = /^\/(?:(?:@[^/]+|(?:channel|c|user|hashtag)\/[^/]+)\/)?shorts(?:\/|$)/;
  // /reels/, /reel/ID, and a profile's Reels tab. /reelhouse/ is a username.
  const INSTAGRAM = /^\/(?:[^/]+\/)?reels?(?:\/|$)/;

  const onSite = (host, site) => host === site || host.endsWith('.' + site);

  function isBlocked(href) {
    let url;
    try {
      url = new URL(href);
    } catch {
      return false;
    }
    if (onSite(url.hostname, 'youtube.com')) return YOUTUBE.test(url.pathname);
    if (onSite(url.hostname, 'instagram.com')) return INSTAGRAM.test(url.pathname);
    return false;
  }

  if (typeof module === 'object' && module.exports) module.exports = { isBlocked };
  if (typeof window === 'undefined') return;

  // Hiding is cosmetic and best effort: these are YouTube's and Instagram's
  // element names, which change. The navigation checks below are what block.
  const CSS = {
    'youtube.com': `
      ytd-guide-entry-renderer:has(a[title="Shorts"]),
      ytd-mini-guide-entry-renderer[aria-label="Shorts"],
      ytd-rich-section-renderer:has(ytd-rich-shelf-renderer[is-shorts]),
      ytd-rich-shelf-renderer[is-shorts],
      ytd-reel-shelf-renderer,
      grid-shelf-view-model:has(ytm-shorts-lockup-view-model, ytm-shorts-lockup-view-model-v2),
      ytm-shorts-lockup-view-model,
      ytm-shorts-lockup-view-model-v2,
      ytd-rich-item-renderer:has(a[href^="/shorts/"]),
      ytd-video-renderer:has(a[href^="/shorts/"]),
      ytd-grid-video-renderer:has(a[href^="/shorts/"]),
      ytd-compact-video-renderer:has(a[href^="/shorts/"]),
      yt-tab-shape[tab-title="Shorts"],
      yt-chip-cloud-chip-renderer:has(yt-formatted-string[title="Shorts"]),
      ytm-reel-shelf-renderer,
      ytm-pivot-bar-item-renderer:has(.pivot-shorts),
      ytm-rich-item-renderer:has(a[href^="/shorts/"]),
      ytm-video-with-context-renderer:has(a[href^="/shorts/"])
      { display: none !important; }`,
    'instagram.com': `
      a[href="/reels/"],
      a[href$="/reels/"][role="tab"]
      { display: none !important; }`,
  };

  const site = Object.keys(CSS).find((s) => onSite(location.hostname, s));
  const style = document.createElement('style');
  style.textContent = CSS[site];
  (document.head || document.documentElement).appendChild(style);

  const home = () => location.replace(location.origin + '/');

  // A click on a Short: stop it before the site's own router sees it. The
  // router would otherwise swap the player in first and push the URL after.
  window.addEventListener(
    'click',
    (event) => {
      const link = event.target instanceof Element && event.target.closest('a[href]');
      if (link && isBlocked(link.href)) {
        event.preventDefault();
        event.stopImmediatePropagation();
      }
    },
    true,
  );

  // Anything else that moves to a Short: pushState from the router, a link
  // opened some other way. Cancelling a same-document push can leave the app
  // half-way into the Shorts player at the old URL, so reload home as well.
  if (window.navigation) {
    navigation.addEventListener('navigate', (event) => {
      if (!isBlocked(event.destination.url)) return;
      if (event.cancelable) event.preventDefault();
      if (event.destination.sameDocument) home();
    });
  }

  // Back/forward into an old Short, or whatever the two above missed.
  const check = () => isBlocked(location.href) && home();
  check();
  setInterval(check, 1000);
})();
