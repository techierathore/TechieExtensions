// Extension helper functions for communication
window.ExtensionHelper = {
    // Get markdown content from storage or background worker
    getMarkdownContent: async function() {
        return new Promise((resolve) => {
            // First try to get from storage (for same-tab redirect)
            if (typeof chrome !== 'undefined' && chrome.storage && chrome.storage.local) {
                chrome.storage.local.get(['pendingContent', 'sourceUrl', 'fileName'], function(result) {
                    if (result.pendingContent) {
                        console.log('Found content in storage, length:', result.pendingContent.length);
                        console.log('File name in storage:', result.fileName);
                        // Store filename globally for later retrieval
                        window._markdownFileName = result.fileName || 'Untitled.md';
                        // Clear the storage after reading
                        chrome.storage.local.remove(['pendingContent', 'sourceUrl', 'fileName']);
                        resolve(result.pendingContent);
                    } else if (chrome.runtime && chrome.runtime.sendMessage) {
                        // Fallback to message passing
                        chrome.runtime.sendMessage({ action: 'getMarkdownContent' }, function(response) {
                            if (chrome.runtime.lastError) {
                                console.error('Error getting content from runtime:', chrome.runtime.lastError);
                                resolve(null);
                            } else {
                                console.log('Received content from runtime:', response);
                                window._markdownFileName = response?.fileName || 'Untitled.md';
                                resolve(response?.content || null);
                            }
                        });
                    } else {
                        console.log('No content source available');
                        resolve(null);
                    }
                });
            } else {
                console.log('Chrome APIs not available');
                resolve(null);
            }
        });
    },
    
    // Get just the filename (from cached value)
    getFileName: async function() {
        return window._markdownFileName || 'Untitled.md';
    },
    
    // Check if we have content waiting
    hasContent: function() {
        return window.location.search.includes('hasContent=true');
    },
    
    // Set document title safely without eval
    setDocumentTitle: function(title) {
        document.title = title;
    }
};