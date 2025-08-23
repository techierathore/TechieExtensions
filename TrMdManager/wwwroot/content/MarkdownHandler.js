// MarkdownHandler.js - Content script for handling Markdown files

(function() {
    'use strict';
    
    console.log('MarkdownHandler.js loaded!');

    // Check if the current page is a Markdown file
    function isMarkdownFile() {
        const url = window.location.href;
        const contentType = document.contentType;
        
        return url.endsWith('.md') || 
               url.endsWith('.markdown') || 
               contentType === 'text/markdown' ||
               contentType === 'text/x-markdown' ||
               (contentType === 'text/plain' && (url.endsWith('.md') || url.endsWith('.markdown')));
    }

    // Get the raw Markdown content from the page
    function getMarkdownContent() {
        // For local files or raw markdown served by servers
        const preElement = document.querySelector('pre');
        if (preElement) {
            console.log('Found pre element, content length:', preElement.textContent.length);
            return preElement.textContent;
        }
        
        // Fallback to body text content
        console.log('Using body text, content length:', document.body.textContent.length);
        return document.body.textContent;
    }

    // Initialize the Markdown viewer
    function initializeMarkdownViewer() {
        if (!isMarkdownFile()) {
            return;
        }

        // Store the original content
        const markdownContent = getMarkdownContent();
        
        console.log('Sending markdown to parse, first 200 chars:', markdownContent.substring(0, 200));
        
        // Try to parse with service worker first (more reliable)
        chrome.runtime.sendMessage({
            action: 'parseMarkdown',
            content: markdownContent,
            sourceUrl: window.location.href
        }, function(response) {
            if (response && response.html) {
                console.log('Received HTML response, first 200 chars:', response.html.substring(0, 200));
                
                // Display the rendered markdown
                displayRenderedMarkdown(markdownContent, response.html);
            } else {
                console.log('No HTML response, falling back to raw display');
                // Fallback to raw display
                displayRawMarkdown(markdownContent);
            }
        });
    }

    function displayRenderedMarkdown(rawContent, htmlContent) {
        // Clear the current page and inject our viewer
        document.documentElement.innerHTML = `
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
            font-size: 16px;
            line-height: 1.5;
            color: #24292e;
            background-color: #ffffff;
        }
        .markdown-container {
            max-width: 980px;
            margin: 0 auto;
            padding: 45px;
        }
        .toolbar {
            position: fixed;
            top: 10px;
            right: 10px;
            background: white;
            border: 1px solid #d1d5da;
            border-radius: 6px;
            padding: 8px;
            box-shadow: 0 1px 3px rgba(27,31,35,0.12);
            z-index: 1000;
            display: flex;
            gap: 8px;
        }
        .toolbar button {
            padding: 5px 16px;
            background: #fafbfc;
            color: #24292e;
            border: 1px solid rgba(27,31,35,0.15);
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }
        .toolbar button:hover {
            background: #f3f4f6;
        }
        .toolbar button.active {
            background: #0969da;
            color: white;
            border-color: #0969da;
        }
        .raw-view {
            white-space: pre-wrap;
            font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
            font-size: 12px;
            line-height: 1.45;
            background-color: #f6f8fa;
            padding: 16px;
            border-radius: 6px;
            overflow: auto;
        }
        
        /* GitHub-like Markdown styles */
        .markdown-content h1,
        .markdown-content h2 {
            border-bottom: 1px solid #e1e4e8;
            padding-bottom: 0.3em;
            margin-top: 24px;
            margin-bottom: 16px;
            font-weight: 600;
        }
        .markdown-content h1 { font-size: 2em; }
        .markdown-content h2 { font-size: 1.5em; }
        .markdown-content h3 { font-size: 1.25em; }
        .markdown-content code {
            padding: 0.2em 0.4em;
            margin: 0;
            font-size: 85%;
            background-color: rgba(175,184,193,0.2);
            border-radius: 6px;
            font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
        }
        .markdown-content pre {
            padding: 16px;
            overflow: auto;
            font-size: 85%;
            line-height: 1.45;
            background-color: #f6f8fa;
            border-radius: 6px;
            margin-bottom: 16px;
        }
        .markdown-content pre code {
            padding: 0;
            background-color: transparent;
            display: block;
            overflow-x: auto;
        }
        .markdown-content ul, .markdown-content ol {
            padding-left: 2em;
            margin-bottom: 16px;
        }
        .markdown-content li {
            margin-bottom: 4px;
        }
        .markdown-content p {
            margin-bottom: 16px;
            line-height: 1.6;
        }
        .markdown-content blockquote {
            padding: 0 1em;
            color: #57606a;
            border-left: 0.25em solid #d1d5da;
            margin: 0 0 16px 0;
        }
        .markdown-content ul,
        .markdown-content ol {
            padding-left: 2em;
            margin-bottom: 16px;
        }
        .markdown-content table {
            border-collapse: collapse;
            margin-bottom: 16px;
        }
        .markdown-content table th,
        .markdown-content table td {
            padding: 6px 13px;
            border: 1px solid #d1d5da;
        }
        .markdown-content table th {
            font-weight: 600;
            background-color: #f6f8fa;
        }
        .markdown-content a {
            color: #0969da;
            text-decoration: none;
        }
        .markdown-content a:hover {
            text-decoration: underline;
        }
        .markdown-content hr {
            height: 0.25em;
            padding: 0;
            margin: 24px 0;
            background-color: #e1e4e8;
            border: 0;
        }
    </style>
</head>
<body>
    <div class="toolbar">
        <button id="toggleView" class="active">Raw</button>
        <button id="openEditor">Open Editor</button>
        <button id="giveFeedback">Give Feedback</button>
    </div>
    <div id="content" class="markdown-container markdown-content">
        ${htmlContent}
    </div>
</body>
</html>`;

        // Setup event handlers after DOM is updated
        setTimeout(() => {
            let isRawView = false;
            const toggleButton = document.getElementById('toggleView');
            const contentDiv = document.getElementById('content');
            
            if (toggleButton && contentDiv) {
                toggleButton.addEventListener('click', function() {
                    isRawView = !isRawView;
                    if (isRawView) {
                        contentDiv.classList.remove('markdown-content');
                        contentDiv.classList.add('raw-view');
                        contentDiv.textContent = rawContent;
                        toggleButton.textContent = 'Preview';
                        toggleButton.classList.remove('active');
                    } else {
                        contentDiv.classList.remove('raw-view');
                        contentDiv.classList.add('markdown-content');
                        contentDiv.innerHTML = htmlContent;
                        toggleButton.textContent = 'Raw';
                        toggleButton.classList.add('active');
                    }
                });
            }
            
            const openEditorButton = document.getElementById('openEditor');
            if (openEditorButton) {
                openEditorButton.addEventListener('click', function() {
                    chrome.runtime.sendMessage({
                        action: 'openEditor',
                        content: rawContent,
                        sourceUrl: window.location.href
                    });
                });
            }
            
            const feedbackButton = document.getElementById('giveFeedback');
            if (feedbackButton) {
                feedbackButton.addEventListener('click', function() {
                    window.open('https://forms.gle/gctmvQ4bYv72PHRA9', '_blank');
                });
            }
        }, 100);
    }

    function displayRawMarkdown(content) {
        // Fallback display if parsing fails
        document.documentElement.innerHTML = `
<!DOCTYPE html>
<html>
<head>
    <title>Markdown Viewer - Techie Mark Down Manager</title>
    <meta charset="UTF-8">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: ui-monospace, SFMono-Regular, Consolas, monospace;
            background-color: #f6f8fa;
        }
        .toolbar {
            position: fixed;
            top: 10px;
            right: 10px;
            background: white;
            border: 1px solid #d1d5da;
            border-radius: 6px;
            padding: 8px;
            z-index: 1000;
        }
        .toolbar button {
            padding: 5px 16px;
            background: #fafbfc;
            color: #24292e;
            border: 1px solid rgba(27,31,35,0.15);
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <div class="toolbar">
        <button id="openEditor">Open Editor</button>
        <button id="giveFeedback">Give Feedback</button>
    </div>
    <pre>${content.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</pre>
</body>
</html>`;
        
        setTimeout(() => {
            const openEditorButton = document.getElementById('openEditor');
            if (openEditorButton) {
                openEditorButton.addEventListener('click', function() {
                    chrome.runtime.sendMessage({
                        action: 'openEditor',
                        content: content,
                        sourceUrl: window.location.href
                    });
                });
            }
            
            const feedbackButton = document.getElementById('giveFeedback');
            if (feedbackButton) {
                feedbackButton.addEventListener('click', function() {
                    window.open('https://forms.gle/gctmvQ4bYv72PHRA9', '_blank');
                });
            }
        }, 100);
    }

    // Run when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeMarkdownViewer);
    } else {
        initializeMarkdownViewer();
    }
})();