// Extension helper functions for communication
window.ExtensionHelper = {
    // Get markdown content from storage or background worker
    getMarkdownContent: async function() {
        return new Promise((resolve) => {
            // First try to get from storage (for same-tab redirect)
            if (typeof chrome !== 'undefined' && chrome.storage && chrome.storage.local) {
                chrome.storage.local.get(['pendingContent', 'sourceUrl'], function(result) {
                    if (result.pendingContent) {
                        console.log('Found content in storage, length:', result.pendingContent.length);
                        // Clear the storage after reading
                        chrome.storage.local.remove(['pendingContent', 'sourceUrl']);
                        resolve(result.pendingContent);
                    } else if (chrome.runtime && chrome.runtime.sendMessage) {
                        // Fallback to message passing
                        chrome.runtime.sendMessage({ action: 'getMarkdownContent' }, function(response) {
                            if (chrome.runtime.lastError) {
                                console.error('Error getting content from runtime:', chrome.runtime.lastError);
                                resolve(null);
                            } else {
                                console.log('Received content from runtime:', response);
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
    
    // Get markdown content with settings from background worker or storage
    getMarkdownContentWithSettings: async function() {
        return new Promise((resolve) => {
            // First try to get from storage (for same-tab redirect)
            if (typeof chrome !== 'undefined' && chrome.storage && chrome.storage.local) {
                chrome.storage.local.get(['pendingContent', 'sourceUrl', 'startInPreview'], function(result) {
                    if (result.pendingContent) {
                        console.log('Found content in storage:', result.pendingContent.substring(0, 100));
                        // Clear the storage after reading
                        chrome.storage.local.remove(['pendingContent', 'sourceUrl', 'startInPreview']);
                        resolve({
                            content: result.pendingContent,
                            startInPreview: result.startInPreview !== false
                        });
                    } else if (chrome.runtime && chrome.runtime.sendMessage) {
                        // Fallback to message passing
                        chrome.runtime.sendMessage({ action: 'getMarkdownContent' }, function(response) {
                            if (chrome.runtime.lastError) {
                                console.error('Error getting content:', chrome.runtime.lastError);
                                resolve(null);
                            } else {
                                console.log('Received content response with settings:', response);
                                resolve({
                                    content: response?.content || null,
                                    startInPreview: response?.startInPreview || false
                                });
                            }
                        });
                    } else {
                        resolve(null);
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