// ==UserScript==
// @name         YouTube Quick Speed Control
// @namespace    dotfiles.youtube-speed-control
// @version      1.6.0
// @description  Add compact, native-looking playback-speed controls to YouTube.
// @match        https://*.youtube.com/*
// @match        https://youtube.com/*
// @match        https://www.youtube-nocookie.com/embed/*
// @run-at       document-idle
// @noframes
// @grant        none
// ==/UserScript==

(() => {
  'use strict';

  const STYLE_ID = 'ytsc-style';
  const CONTROL_CLASS = 'ytsc-speed-control';
  const TOAST_CLASS = 'ytsc-speed-toast';
  const PREFERRED_RATE_KEY = 'ytsc-preferred-rate';
  const STEP = 0.1;
  const FAST_STEP = 0.25;
  const MIN_RATE = 0.25;
  const MAX_RATE = 4;
  const WHEEL_THRESHOLD = 40;

  const clampRate = (rate) => Math.min(MAX_RATE, Math.max(MIN_RATE, Math.round(rate * 100) / 100));

  function formatRate(rate) {
    const value = Number(rate.toFixed(2));
    return `${value}×`;
  }

  function getPlayer(node) {
    return node?.closest('.html5-video-player, #movie_player, ytd-player') ?? null;
  }

  function getVideo(player) {
    return player?.querySelector('video.html5-main-video')
      ?? player?.querySelector('video')
      ?? null;
  }

  function readPreferredRate() {
    try {
      const stored = Number.parseFloat(localStorage.getItem(PREFERRED_RATE_KEY));
      return Number.isFinite(stored) ? clampRate(stored) : null;
    } catch {
      return null;
    }
  }

  function savePreferredRate(rate) {
    try {
      localStorage.setItem(PREFERRED_RATE_KEY, String(rate));
    } catch {
      // Storage may be disabled; the control still works for the current video.
    }
  }

  function addStyles() {
    if (document.getElementById(STYLE_ID)) return;

    const style = document.createElement('style');
    style.id = STYLE_ID;
    style.textContent = `
      .${CONTROL_CLASS} {
        align-items: center;
        display: inline-flex;
        height: 40px;
        margin: 0 2px;
        vertical-align: top;
      }

      .${CONTROL_CLASS}.ytsc-floating {
        bottom: 8px;
        pointer-events: auto;
        position: absolute;
        right: 72px;
        z-index: 101;
      }

      .${CONTROL_CLASS} .ytsc-button.ytp-button {
        align-items: center;
        background: transparent;
        border: 0;
        border-radius: 2px;
        color: #fff;
        display: flex;
        font-family: Roboto, Arial, sans-serif;
        height: 40px;
        justify-content: center;
        min-width: 30px;
        opacity: .9;
        padding: 0;
        transition: background-color .1s ease, opacity .1s ease;
      }

      .${CONTROL_CLASS} .ytsc-button.ytp-button:hover,
      .${CONTROL_CLASS} .ytsc-button.ytp-button:focus-visible {
        background: transparent !important;
        opacity: 1;
      }

      .${CONTROL_CLASS} .ytsc-button.ytp-button:focus-visible {
        outline: 1px solid rgba(255, 255, 255, .85);
        outline-offset: -2px;
      }

      .${CONTROL_CLASS} .ytsc-step {
        width: 28px;
      }

      .${CONTROL_CLASS} .ytsc-rate {
        font-size: 12px;
        font-variant-numeric: tabular-nums;
        font-weight: 500;
        letter-spacing: .1px;
        min-width: 42px;
        width: 42px;
      }

      .${CONTROL_CLASS} svg {
        fill: none;
        height: 18px;
        stroke: currentColor;
        stroke-linecap: round;
        stroke-linejoin: round;
        stroke-width: 2;
        width: 18px;
      }

      .${TOAST_CLASS} {
        background: rgba(0, 0, 0, .8);
        border-radius: 3px;
        bottom: 58px;
        color: #fff;
        font: 500 14px Roboto, Arial, sans-serif;
        left: 50%;
        opacity: 0;
        padding: 8px 12px;
        pointer-events: none;
        position: absolute;
        transform: translate(-50%, 8px);
        transition: opacity .12s ease, transform .12s ease;
        white-space: nowrap;
        z-index: 100;
      }

      .${TOAST_CLASS}.ytsc-visible {
        opacity: 1;
        transform: translate(-50%, 0);
      }

      @media (max-width: 500px) {
        .${CONTROL_CLASS} {
          margin: 0;
        }

        .${CONTROL_CLASS} .ytsc-step {
          min-width: 24px;
          width: 24px;
        }

        .${CONTROL_CLASS} .ytsc-rate {
          min-width: 36px;
          width: 36px;
        }
      }
    `;
    (document.head ?? document.documentElement).appendChild(style);
  }

  function showToast(player, rate) {
    if (!player) return;

    let toast = player.querySelector(`.${TOAST_CLASS}`);
    if (!toast) {
      toast = document.createElement('div');
      toast.className = TOAST_CLASS;
      toast.setAttribute('aria-live', 'polite');
      player.appendChild(toast);
    }

    toast.textContent = `Speed ${formatRate(rate)}`;
    toast.classList.remove('ytsc-visible');
    // Restart the transition if several clicks happen quickly.
    void toast.offsetWidth;
    toast.classList.add('ytsc-visible');
    clearTimeout(toast.ytscHideTimer);
    toast.ytscHideTimer = window.setTimeout(() => {
      toast.classList.remove('ytsc-visible');
    }, 700);
  }

  function updateRateLabel(control, video) {
    const rateLabel = control.querySelector('.ytsc-rate');
    if (!rateLabel) return;

    const rate = Number.isFinite(video?.playbackRate) ? video.playbackRate : 1;
    const formattedRate = formatRate(rate);
    const label = `Playback speed ${formattedRate}; click to reset to 1×`;
    const title = `Playback speed ${formattedRate} — click to reset to 1×`;

    if (rateLabel.textContent !== formattedRate) rateLabel.textContent = formattedRate;
    if (rateLabel.getAttribute('aria-label') !== label) rateLabel.setAttribute('aria-label', label);
    if (rateLabel.title !== title) rateLabel.title = title;
  }

  function setRate(video, rate, { announce = true, remember = true } = {}) {
    if (!video) return;

    const nextRate = clampRate(rate);
    video.playbackRate = nextRate;
    if (remember) savePreferredRate(nextRate);

    const player = getPlayer(video);
    if (player) {
      player.querySelectorAll(`.${CONTROL_CLASS}`).forEach((control) => {
        updateRateLabel(control, video);
      });
      if (announce) showToast(player, nextRate);
    }
  }

  function changeRate(control, direction, event) {
    const player = getPlayer(control);
    const video = getVideo(player);
    if (!video) return;

    const currentRate = Number.isFinite(video.playbackRate) ? video.playbackRate : 1;
    const step = event.shiftKey ? FAST_STEP : STEP;
    setRate(video, currentRate + direction * step);
  }

  function arrowIcon(direction) {
    const pathData = direction < 0
      ? 'M14.5 5 7.5 12l7 7'
      : 'm9.5 5 7 7-7 7';
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    svg.setAttribute('viewBox', '0 0 24 24');
    svg.setAttribute('aria-hidden', 'true');
    path.setAttribute('d', pathData);
    svg.appendChild(path);
    return svg;
  }

  function makeButton(className, label, title, content) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = `ytp-button ytsc-button ${className}`;
    button.setAttribute('aria-label', label);
    button.title = title;
    if (typeof content === 'string') button.textContent = content;
    else button.appendChild(content);
    return button;
  }

  function bindVideo(control, video) {
    if (control.ytscVideo === video) {
      updateRateLabel(control, video);
      return;
    }

    if (control.ytscVideo && control.ytscListeners) {
      for (const [eventName, listener] of control.ytscListeners) {
        control.ytscVideo.removeEventListener(eventName, listener);
      }
    }

    control.ytscVideo = video;
    control.ytscAppliedSource = null;

    const applyPreferredRate = () => {
      updateRateLabel(control, video);

      const preferredRate = readPreferredRate();
      if (preferredRate === null) return;

      const source = video.currentSrc || video.src || '';
      if (control.ytscAppliedSource === source) return;
      control.ytscAppliedSource = source;

      window.setTimeout(() => {
        if (getVideo(getPlayer(control)) !== video) return;
        if ((video.currentSrc || video.src || '') !== source) return;
        if (Math.abs(video.playbackRate - preferredRate) > 0.001) {
          setRate(video, preferredRate, { announce: false, remember: false });
        }
      }, 0);
    };

    const update = () => updateRateLabel(control, video);
    control.ytscListeners = [
      ['ratechange', update],
      ['loadedmetadata', applyPreferredRate],
      ['durationchange', applyPreferredRate],
    ];

    for (const [eventName, listener] of control.ytscListeners) {
      video.addEventListener(eventName, listener);
    }

    update();
    if (video.readyState >= 1) applyPreferredRate();
  }

  function getControlAnchor(container) {
    const candidate = container?.querySelector(
      '.ytp-autonav-toggle, .ytp-settings-button, .ytp-size-button, .ytp-fullscreen-button',
    );
    return candidate?.parentElement === container ? candidate : null;
  }

  function getNativeControlHost(player) {
    return player.querySelector('.ytp-right-controls-left')
      ?? player.querySelector('.ytp-right-controls-right')
      ?? player.querySelector('.ytp-right-controls');
  }

  function getControlHost(player) {
    const rightControls = getNativeControlHost(player);
    if (rightControls) return { element: rightControls, floating: false };

    const chromeControls = player.querySelector('.ytp-chrome-controls, .ytp-chrome-bottom');
    if (chromeControls) return { element: chromeControls, floating: true };

    return { element: player, floating: true };
  }

  function createControl(player) {
    if (!getVideo(player)) return;

    const rightControls = getNativeControlHost(player);
    const existing = player.querySelector(`.${CONTROL_CLASS}`);
    if (existing) {
      // Move a temporary fallback control into YouTube's native control bar once
      // YouTube finishes rendering it.
      if (rightControls && existing.parentElement !== rightControls) {
        existing.classList.remove('ytsc-floating');
        rightControls.insertBefore(existing, getControlAnchor(rightControls));
      }
      return;
    }

    const { element: host, floating } = getControlHost(player);
    const control = document.createElement('div');
    control.className = CONTROL_CLASS;
    control.classList.toggle('ytsc-floating', floating);
    control.setAttribute('role', 'group');
    control.setAttribute('aria-label', 'Playback speed');

    const slower = makeButton(
      'ytsc-step',
      'Decrease playback speed',
      'Decrease speed by 0.1× (Shift-click: 0.25×)',
      arrowIcon(-1),
    );
    const rate = makeButton(
      'ytsc-rate',
      'Playback speed',
      'Click to reset speed to 1×',
      '1×',
    );
    const faster = makeButton(
      'ytsc-step',
      'Increase playback speed',
      'Increase speed by 0.1× (Shift-click: 0.25×)',
      arrowIcon(1),
    );

    control.append(slower, rate, faster);
    host.insertBefore(control, getControlAnchor(host));

    const stopClick = (event) => {
      event.preventDefault();
      event.stopPropagation();
    };

    slower.addEventListener('click', (event) => {
      stopClick(event);
      changeRate(control, -1, event);
    });

    faster.addEventListener('click', (event) => {
      stopClick(event);
      changeRate(control, 1, event);
    });

    rate.addEventListener('click', (event) => {
      stopClick(event);
      const video = getVideo(getPlayer(control));
      if (video) setRate(video, 1);
    });

    let wheelDistance = 0;
    control.addEventListener('wheel', (event) => {
      const video = getVideo(getPlayer(control));
      if (!video || event.deltaY === 0) return;

      event.preventDefault();
      event.stopPropagation();

      const delta = event.deltaMode === WheelEvent.DOM_DELTA_LINE
        ? event.deltaY * 16
        : event.deltaY;
      wheelDistance += delta;

      const steps = Math.trunc(Math.abs(wheelDistance) / WHEEL_THRESHOLD);
      if (steps === 0) return;

      const direction = wheelDistance < 0 ? 1 : -1;
      wheelDistance -= Math.sign(wheelDistance) * steps * WHEEL_THRESHOLD;
      const step = event.shiftKey ? FAST_STEP : STEP;
      const currentRate = Number.isFinite(video.playbackRate) ? video.playbackRate : 1;
      setRate(video, currentRate + direction * steps * step);
    }, { passive: false });

    control.addEventListener('mouseleave', () => {
      wheelDistance = 0;
    });
  }

  function syncControls() {
    const players = new Set(document.querySelectorAll(
      '.html5-video-player, #movie_player, ytd-player',
    ));

    players.forEach((player) => {
      createControl(player);
      const video = getVideo(player);
      player.querySelectorAll(`.${CONTROL_CLASS}`).forEach((control) => {
        if (video) bindVideo(control, video);
      });
    });
  }

  function isEditableTarget(target) {
    return target instanceof HTMLElement
      && (target.matches('input, textarea, select, [contenteditable="true"]')
        || target.isContentEditable);
  }

  document.addEventListener('keydown', (event) => {
    if (event.defaultPrevented || event.ctrlKey || event.metaKey || event.altKey || isEditableTarget(event.target)) {
      return;
    }

    const direction = event.key === '[' ? -1 : event.key === ']' ? 1 : 0;
    if (!direction) return;

    const video = document.querySelector('video.html5-main-video');
    const player = getPlayer(video);
    const control = player?.querySelector(`.${CONTROL_CLASS}`);
    if (!video || !control) return;

    event.preventDefault();
    event.stopPropagation();
    changeRate(control, direction, event);
  }, true);

  let installScheduled = false;
  const scheduleSync = () => {
    if (installScheduled) return;
    installScheduled = true;
    window.requestAnimationFrame(() => {
      installScheduled = false;
      addStyles();
      syncControls();
    });
  };

  addStyles();
  syncControls();

  const observer = new MutationObserver(scheduleSync);
  observer.observe(document.documentElement, { childList: true, subtree: true });

  for (const eventName of ['yt-navigate-finish', 'yt-page-data-updated', 'yt-player-updated', 'popstate', 'hashchange']) {
    window.addEventListener(eventName, scheduleSync);
  }

  // YouTube occasionally replaces the player controls without emitting a useful
  // navigation event. Keep a cheap retry so the control comes back after that.
  window.setInterval(scheduleSync, 1000);
})();
