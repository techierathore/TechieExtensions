// JSON Editor helper functions

// Download JSON file
window.downloadJson = function(content, filename) {
    const blob = new Blob([content], { type: 'application/json;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename || 'data.json';
    link.click();
    URL.revokeObjectURL(url);
};

// Insert text at cursor position
window.insertTextAtCursor = function(element, text) {
    const start = element.selectionStart;
    const end = element.selectionEnd;
    const value = element.value;
    
    element.value = value.substring(0, start) + text + value.substring(end);
    element.selectionStart = element.selectionEnd = start + text.length;
    
    // Trigger input event
    const event = new Event('input', { bubbles: true });
    element.dispatchEvent(event);
};

// Extension helper for content communication
window.ExtensionHelper = {
    // Get JSON content from background worker
    getJsonContent: async function() {
        return new Promise((resolve) => {
            if (typeof chrome !== 'undefined' && chrome.runtime && chrome.runtime.sendMessage) {
                chrome.runtime.sendMessage({ action: 'getJsonContent' }, function(response) {
                    if (chrome.runtime.lastError) {
                        console.error('Error getting content:', chrome.runtime.lastError);
                        resolve(null);
                    } else {
                        resolve(response?.content || null);
                    }
                });
            } else {
                resolve(null);
            }
        });
    },
    
    // Check if we have content waiting
    hasContent: function() {
        return window.location.search.includes('hasContent=true');
    }
};