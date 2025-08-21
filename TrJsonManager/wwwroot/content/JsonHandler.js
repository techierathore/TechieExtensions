// JsonHandler.js - Content script for handling JSON files

(function() {
    'use strict';

    // Check if the current page is a JSON file
    function isJsonFile() {
        const url = window.location.href;
        const contentType = document.contentType;
        
        // Check file extension or content type
        return url.endsWith('.json') || 
               contentType === 'application/json' ||
               contentType === 'text/json';
    }

    // Get the raw JSON content from the page
    function getJsonContent() {
        // For Chrome/Edge JSON viewer
        const preElement = document.querySelector('pre');
        if (preElement) {
            return preElement.textContent;
        }
        
        // For Firefox or raw JSON
        const bodyText = document.body.textContent || document.body.innerText;
        
        // Try to validate if it's JSON
        try {
            JSON.parse(bodyText);
            return bodyText;
        } catch {
            return null;
        }
    }

    // Initialize the JSON viewer
    function initializeJsonViewer() {
        if (!isJsonFile()) {
            // Also check if the content looks like JSON
            const content = getJsonContent();
            if (!content) {
                return;
            }
        }

        // Store the original content
        const jsonContent = getJsonContent();
        if (!jsonContent) {
            return;
        }
        
        // Clear the current page
        document.documentElement.innerHTML = '';
        
        // Create a new HTML structure
        const html = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>JSON Viewer - Techie JSON Manager</title>
                <meta charset="UTF-8">
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
                        background-color: #f5f5f5;
                    }
                    .json-container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 20px;
                    }
                    .toolbar {
                        position: fixed;
                        top: 10px;
                        right: 10px;
                        background: white;
                        border: 1px solid #ddd;
                        border-radius: 4px;
                        padding: 5px;
                        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                        z-index: 1000;
                    }
                    .toolbar button {
                        margin: 0 2px;
                        padding: 5px 10px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 3px;
                        cursor: pointer;
                    }
                    .toolbar button:hover {
                        opacity: 0.9;
                    }
                    .raw-view {
                        white-space: pre-wrap;
                        font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
                        background: white;
                        padding: 20px;
                        border-radius: 4px;
                        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                    }
                    .loading {
                        text-align: center;
                        padding: 40px;
                        color: #666;
                    }
                </style>
            </head>
            <body>
                <div class="toolbar">
                    <button id="openEditor">Open in Editor</button>
                    <button id="copyJson">Copy JSON</button>
                </div>
                <div id="content" class="json-container">
                    <div class="raw-view"></div>
                </div>
            </body>
            </html>
        `;
        
        document.open();
        document.write(html);
        document.close();
        
        // Display formatted JSON
        const contentDiv = document.querySelector('.raw-view');
        try {
            const parsed = JSON.parse(jsonContent);
            contentDiv.textContent = JSON.stringify(parsed, null, 2);
        } catch {
            contentDiv.textContent = jsonContent;
        }
        
        // Open editor button
        document.getElementById('openEditor').addEventListener('click', function() {
            // Send message to background script to open the editor
            chrome.runtime.sendMessage({
                action: 'openJsonEditor',
                content: jsonContent,
                sourceUrl: window.location.href
            }, function(response) {
                if (chrome.runtime.lastError) {
                    console.error('Error opening editor:', chrome.runtime.lastError);
                }
            });
        });
        
        // Copy JSON button
        document.getElementById('copyJson').addEventListener('click', function() {
            navigator.clipboard.writeText(jsonContent).then(function() {
                const btn = document.getElementById('copyJson');
                const originalText = btn.textContent;
                btn.textContent = 'Copied!';
                setTimeout(() => {
                    btn.textContent = originalText;
                }, 2000);
            });
        });
    }

    // Run when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeJsonViewer);
    } else {
        initializeJsonViewer();
    }
})();