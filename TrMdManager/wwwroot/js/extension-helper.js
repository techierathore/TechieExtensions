// Extension helper functions for communication
window.ExtensionHelper = {
    // Get markdown content from background worker
    getMarkdownContent: async function() {
        return new Promise((resolve) => {
            if (typeof chrome !== 'undefined' && chrome.runtime && chrome.runtime.sendMessage) {
                chrome.runtime.sendMessage({ action: 'getMarkdownContent' }, function(response) {
                    if (chrome.runtime.lastError) {
                        console.error('Error getting content:', chrome.runtime.lastError);
                        resolve(null);
                    } else {
                        console.log('Received content response:', response);
                        resolve(response?.content || null);
                    }
                });
            } else {
                console.log('Chrome runtime not available');
                resolve(null);
            }
        });
    },
    
    // Check if we have content waiting
    hasContent: function() {
        return window.location.search.includes('hasContent=true');
    }
};