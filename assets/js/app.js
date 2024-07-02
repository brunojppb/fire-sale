// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import PhotoSwipeLightbox from "../vendor/photoswipe/photoswipe-lightbox.esm.js";
import PhotoSwipe from "../vendor/photoswipe/photoswipe.esm.js";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

window.addEventListener("phx:gallery", (e) => {
  const lightbox = new PhotoSwipeLightbox({
    gallery: "#product-gallery",
    children: "a.gallery-item",
    pswpModule: PhotoSwipe,
  });
  lightbox.init();
});

// Custom hooks
window.addEventListener("fire_sale:toggle_theme", (event) => {
  try {
    const body = document.querySelector("body");
    const isDark = body.className.includes("dark");
    if (isDark) {
      body.classList.remove("dark");
      window.localStorage.setItem("theme", "light");
    } else {
      body.classList.add("dark");
      window.localStorage.setItem("theme", "dark");
    }
  } catch (e) {
    console.error("Could not set theme", e);
  }
});

function initTheme() {
  try {
    const body = document.querySelector("body");
    const currentTheme = window.localStorage.getItem("theme");
    if (currentTheme === null) {
      window.localStorage.setItem("theme", "dark");
      // by default, we render "dark" on the body
    } else {
      if (currentTheme === "light") {
        body.classList.remove("dark");
        window.localStorage.setItem("theme", "light");
      }
    }
  } catch (e) {
    console.error("Could not init theme", e);
  }
}

initTheme();
