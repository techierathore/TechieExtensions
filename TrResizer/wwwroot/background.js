// Cross-browser API support
const browserAPI = typeof browser !== 'undefined' ? browser : chrome;

browserAPI.runtime.onInstalled.addListener(() => {
    console.log('TrResizer extension installed');
});

// Handle action click if popup is not set
browserAPI.action.onClicked.addListener((tab) => {
    browserAPI.action.openPopup();
});