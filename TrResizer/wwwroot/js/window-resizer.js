// Cross-browser API support
const browserAPI = (typeof chrome !== 'undefined' && chrome.windows) ? chrome : 
                  (typeof browser !== 'undefined' && browser.windows) ? browser : null;

export function getCurrentWindowSize() {
    return new Promise((resolve, reject) => {
        if (!browserAPI) {
            reject("Browser extension API not available");
            return;
        }
        
        try {
            browserAPI.tabs.query({ active: true, currentWindow: true }, function(tabs) {
                if (tabs && tabs.length > 0) {
                    browserAPI.windows.get(tabs[0].windowId, function(windowObj) {
                        if (browserAPI.runtime.lastError) {
                            reject(browserAPI.runtime.lastError.message);
                        } else {
                            resolve({
                                width: windowObj.width,
                                height: windowObj.height
                            });
                        }
                    });
                } else {
                    // Fallback values
                    resolve({
                        width: 1024,
                        height: 768
                    });
                }
            });
        } catch (error) {
            reject(error.message);
        }
    });
}

export function resizeWindow(width, height) {
    return new Promise((resolve, reject) => {
        if (!browserAPI) {
            reject("Browser extension API not available");
            return;
        }
        
        try {
            browserAPI.tabs.query({ active: true, currentWindow: true }, function(tabs) {
                if (tabs && tabs.length > 0) {
                    browserAPI.windows.update(tabs[0].windowId, {
                        width: parseInt(width),
                        height: parseInt(height)
                    }, function(windowObj) {
                        if (browserAPI.runtime.lastError) {
                            reject(browserAPI.runtime.lastError.message);
                        } else {
                            resolve();
                        }
                    });
                } else {
                    reject("No active tab found");
                }
            });
        } catch (error) {
            reject(error.message);
        }
    });
}