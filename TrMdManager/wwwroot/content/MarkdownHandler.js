// MarkdownHandler.js - Content script for handling Markdown files

(function() {
    'use strict';

    // Check if the current page is a Markdown file
    function isMarkdownFile() {
        const url = window.location.href;
        const contentType = document.contentType;
        
        return url.endsWith('.md') || 
               url.endsWith('.markdown') || 
               contentType === 'text/markdown' ||
               contentType === 'text/x-markdown';
    }

    // Get the raw Markdown content from the page
    function getMarkdownContent() {
        // For local files or raw markdown served by servers
        const preElement = document.querySelector('pre');
        if (preElement) {
            return preElement.textContent;
        }
        
        // Fallback to body text content
        return document.body.textContent;
    }

    // Initialize the Markdown viewer
    function initializeMarkdownViewer() {
        if (!isMarkdownFile()) {
            return;
        }

        // Store the original content
        const markdownContent = getMarkdownContent();
        
        // Clear the current page
        document.documentElement.innerHTML = '';
        
        // Create a new HTML structure
        const html = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>Markdown Viewer - Techie Mark Down Manager</title>
                <meta charset="UTF-8">
                <style>
                    body {
                        margin: 0;
                        padding: 0;
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
                        background-color: #fff;
                    }
                    .markdown-container {
                        max-width: 900px;
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
                        background: #007bff;
                        color: white;
                        border: none;
                        border-radius: 3px;
                        cursor: pointer;
                    }
                    .toolbar button:hover {
                        background: #0056b3;
                    }
                    .raw-view {
                        white-space: pre-wrap;
                        font-family: 'Courier New', monospace;
                    }
                </style>
            </head>
            <body>
                <div class="toolbar">
                    <button id="toggleView">Toggle Raw</button>
                    <button id="openEditor">Open Editor</button>
                </div>
                <div id="content" class="markdown-container">
                    <div class="loading">Loading Markdown viewer...</div>
                </div>
            </body>
            </html>
        `;
        
        document.open();
        document.write(html);
        document.close();
        
        // Store markdown content in data attribute
        document.body.dataset.markdownContent = markdownContent;
        
        // Setup toggle functionality
        let isRawView = true; // Start with raw view since we can't render yet
        const toggleButton = document.getElementById('toggleView');
        const contentDiv = document.getElementById('content');
        
        // Initially show raw content
        contentDiv.classList.add('raw-view');
        contentDiv.textContent = markdownContent;
        toggleButton.textContent = 'View Preview';
        
        toggleButton.addEventListener('click', function() {
            isRawView = !isRawView;
            if (isRawView) {
                contentDiv.classList.add('raw-view');
                contentDiv.textContent = markdownContent;
                toggleButton.textContent = 'View Preview';
            } else {
                contentDiv.classList.remove('raw-view');
                // For now, show a simple message since we need the Blazor app to render
                contentDiv.innerHTML = `
                    <div style="padding: 20px;">
                        <p><strong>Preview mode requires the full editor.</strong></p>
                        <p>Click "Open Editor" to view the rendered Markdown with full editing capabilities.</p>
                        <hr style="margin: 20px 0;">
                        <div class="raw-view" style="background: #f6f8fa; padding: 15px; border-radius: 5px;">
                            <pre>${markdownContent.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</pre>
                        </div>
                    </div>
                `;
                toggleButton.textContent = 'View Raw';
            }
        });
        
        // Open editor button - use chrome.runtime.sendMessage to open editor
        document.getElementById('openEditor').addEventListener('click', function() {
            // Send message to background script to open the editor
            chrome.runtime.sendMessage({
                action: 'openEditor',
                content: markdownContent,
                sourceUrl: window.location.href
            }, function(response) {
                if (chrome.runtime.lastError) {
                    console.error('Error opening editor:', chrome.runtime.lastError);
                } else {
                    console.log('Editor opened successfully');
                }
            });
        });
    }

    // Run when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeMarkdownViewer);
    } else {
        initializeMarkdownViewer();
    }
})();