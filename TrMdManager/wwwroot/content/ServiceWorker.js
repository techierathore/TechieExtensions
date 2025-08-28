// BackgroundWorker.js - Service worker for the Markdown extension

// Store for pending markdown content when opening editor
let pendingMarkdownContent = null;
let pendingSourceUrl = null;

// Handle extension installation
chrome.runtime.onInstalled.addListener((details) => {
    console.log('Techie Mark Down Manager installed', details);
    
    // Set default storage values if needed
    chrome.storage.local.get(['theme', 'fontSize'], (result) => {
        if (!result.theme) {
            chrome.storage.local.set({ 
                theme: 'light',
                fontSize: '16px',
                autoSave: true
            });
        }
    });
});

// Comprehensive markdown to HTML converter
function parseMarkdown(markdown) {
    if (!markdown) return '';
    
    // Helper function to escape HTML (works in service worker context)
    const escapeHtml = (text) => {
        return text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    };
    
    // Store placeholders for code blocks and other pre-formatted content
    const placeholders = [];
    let placeholderIndex = 0;
    
    const createPlaceholder = (content) => {
        const placeholder = `___PLACEHOLDER_${placeholderIndex}___`;
        placeholders[placeholderIndex] = content;
        placeholderIndex++;
        return placeholder;
    };
    
    let html = markdown;
    
    // Step 1: Protect fenced code blocks (```code```)
    html = html.replace(/```([a-zA-Z]*)\r?\n([\s\S]*?)```/g, (match, lang, code) => {
        const escapedCode = escapeHtml(code.trim());
        return createPlaceholder(`<pre><code class="language-${lang || 'plaintext'}">${escapedCode}</code></pre>`);
    });
    
    // Step 2: Protect inline code (`code`)
    html = html.replace(/`([^`\r\n]+)`/g, (match, code) => {
        return createPlaceholder(`<code>${escapeHtml(code)}</code>`);
    });
    
    // Step 3: Escape HTML in the remaining content
    html = escapeHtml(html);
    
    // Step 4: Process block elements
    
    // Headers
    html = html.replace(/^######\s+(.+)$/gm, '<h6>$1</h6>');
    html = html.replace(/^#####\s+(.+)$/gm, '<h5>$1</h5>');
    html = html.replace(/^####\s+(.+)$/gm, '<h4>$1</h4>');
    html = html.replace(/^###\s+(.+)$/gm, '<h3>$1</h3>');
    html = html.replace(/^##\s+(.+)$/gm, '<h2>$1</h2>');
    html = html.replace(/^#\s+(.+)$/gm, '<h1>$1</h1>');
    
    // Horizontal rules
    html = html.replace(/^(\*{3,}|-{3,}|_{3,})$/gm, '<hr>');
    
    // Blockquotes
    html = html.replace(/^&gt;\s+(.+)$/gm, '<blockquote>$1</blockquote>');
    html = html.replace(/<\/blockquote>\n<blockquote>/g, '\n');
    
    // Step 5: Process lists
    const lines = html.split('\n');
    const processedLines = [];
    let inOrderedList = false;
    let inUnorderedList = false;
    let currentListItems = [];
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        const trimmedLine = line.trim();
        
        // Check for numbered list items
        const orderedMatch = line.match(/^(\d+)\.\s+(.+)$/);
        if (orderedMatch) {
            if (inUnorderedList && currentListItems.length > 0) {
                processedLines.push('<ul>' + currentListItems.join('') + '</ul>');
                currentListItems = [];
                inUnorderedList = false;
            }
            inOrderedList = true;
            currentListItems.push(`<li>${orderedMatch[2]}</li>`);
            continue;
        }
        
        // Check for unordered list items
        const unorderedMatch = line.match(/^[\*\-\+]\s+(.+)$/);
        if (unorderedMatch) {
            if (inOrderedList && currentListItems.length > 0) {
                processedLines.push('<ol>' + currentListItems.join('') + '</ol>');
                currentListItems = [];
                inOrderedList = false;
            }
            inUnorderedList = true;
            currentListItems.push(`<li>${unorderedMatch[1]}</li>`);
            continue;
        }
        
        // If we're not in a list item anymore, close the current list
        if ((inOrderedList || inUnorderedList) && currentListItems.length > 0) {
            if (inOrderedList) {
                processedLines.push('<ol>' + currentListItems.join('') + '</ol>');
                inOrderedList = false;
            } else if (inUnorderedList) {
                processedLines.push('<ul>' + currentListItems.join('') + '</ul>');
                inUnorderedList = false;
            }
            currentListItems = [];
        }
        
        processedLines.push(line);
    }
    
    // Close any remaining lists
    if (currentListItems.length > 0) {
        if (inOrderedList) {
            processedLines.push('<ol>' + currentListItems.join('') + '</ol>');
        } else if (inUnorderedList) {
            processedLines.push('<ul>' + currentListItems.join('') + '</ul>');
        }
    }
    
    html = processedLines.join('\n');
    
    // Step 6: Process inline elements
    
    // Bold
    html = html.replace(/\*\*([^\*]+)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/__([^_]+)__/g, '<strong>$1</strong>');
    
    // Italic
    html = html.replace(/\*([^\*\n]+)\*/g, '<em>$1</em>');
    html = html.replace(/_([^_\n]+)_/g, '<em>$1</em>');
    
    // Strikethrough
    html = html.replace(/~~([^~]+)~~/g, '<del>$1</del>');
    
    // Links
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
    
    // Images
    html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, '<img src="$2" alt="$1">');
    
    // Step 7: Process paragraphs
    html = html.split(/\n\n+/).map(block => {
        block = block.trim();
        // Don't wrap if it's already an HTML element
        if (block.match(/^<(?:h[1-6]|ul|ol|li|blockquote|pre|hr|p|div|table)/)) {
            return block;
        }
        // Don't wrap placeholders
        if (block.match(/^___PLACEHOLDER_\d+___$/)) {
            return block;
        }
        // Don't wrap empty blocks
        if (block === '') {
            return '';
        }
        // Wrap in paragraph tags
        return `<p>${block}</p>`;
    }).join('\n\n');
    
    // Step 8: Restore placeholders
    placeholders.forEach((content, index) => {
        const placeholder = `___PLACEHOLDER_${index}___`;
        html = html.replace(new RegExp(placeholder, 'g'), content);
    });
    
    // Step 9: Clean up extra newlines
    html = html.replace(/\n{3,}/g, '\n\n');
    
    return html;
}

// Handle messages from content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log('Background worker received message:', request.action);
    
    if (request.action === 'parseMarkdown') {
        // Parse the markdown content
        try {
            console.log('Parsing markdown, input length:', (request.content || '').length);
            console.log('First 200 chars of input:', (request.content || '').substring(0, 200));
            const htmlContent = parseMarkdown(request.content || '');
            console.log('Generated HTML length:', htmlContent.length);
            console.log('First 200 chars of HTML:', htmlContent.substring(0, 200));
            sendResponse({ 
                success: true,
                html: htmlContent
            });
        } catch (error) {
            console.error('Error parsing markdown:', error);
            sendResponse({ 
                success: false,
                error: error.message
            });
        }
        return true;
    }
    
    if (request.action === 'openEditorInCurrentTab') {
        // Store the markdown content temporarily
        const content = request.content || '';
        const sourceUrl = request.sourceUrl || '';
        const fileName = request.fileName || 'Untitled.md';
        const startInPreview = request.startInPreview || false;
        
        // Store in storage first
        chrome.storage.local.set({ 
            pendingContent: content,
            sourceUrl: sourceUrl,
            fileName: fileName,
            startInPreview: startInPreview
        }, function() {
            // Get the current tab and update its URL
            chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
                if (tabs && tabs[0]) {
                    const params = new URLSearchParams({
                        hasContent: 'true',
                        preview: startInPreview ? 'true' : 'false'
                    });
                    const editorUrl = chrome.runtime.getURL(`index.html?${params.toString()}`);
                    
                    // Update the current tab's URL
                    chrome.tabs.update(tabs[0].id, {url: editorUrl}, function() {
                        sendResponse({ success: true });
                    });
                } else {
                    sendResponse({ success: false, error: 'No active tab found' });
                }
            });
        });
        
        return true; // Keep the message channel open for async response
    }
    
    if (request.action === 'openEditor') {
        // Store the markdown content temporarily
        pendingMarkdownContent = request.content || '';
        pendingSourceUrl = request.sourceUrl || '';
        const fileName = request.fileName || 'Untitled.md';
        const startInPreview = request.startInPreview || false;
        
        // Store in storage first
        chrome.storage.local.set({ 
            pendingContent: pendingMarkdownContent,
            sourceUrl: pendingSourceUrl,
            fileName: fileName,
            startInPreview: startInPreview
        }, function() {
            // Open the editor in a new tab with parameters
            const params = new URLSearchParams({
                hasContent: 'true',
                preview: startInPreview ? 'true' : 'false'
            });
            chrome.tabs.create({
                url: chrome.runtime.getURL(`index.html?${params.toString()}`)
            }, (tab) => {
                // Store the tab ID so we can send the content when the editor is ready
                if (tab && tab.id) {
                    chrome.storage.local.set({ 
                        editorTabId: tab.id
                    });
                }
            });
        });
        
        sendResponse({ success: true });
        return true;
    }
    
    if (request.action === 'getMarkdownContent') {
        // Return any pending content
        chrome.storage.local.get(['pendingContent', 'sourceUrl', 'fileName', 'startInPreview'], (result) => {
            const content = result.pendingContent || pendingMarkdownContent || '';
            const url = result.sourceUrl || pendingSourceUrl || '';
            const fileName = result.fileName || 'Untitled.md';
            const startInPreview = result.startInPreview || false;
            
            console.log('Returning markdown content:', content.substring(0, 100) + '...');
            console.log('File name:', fileName);
            
            // Clear the pending content after sending
            chrome.storage.local.remove(['pendingContent', 'sourceUrl', 'startInPreview']);
            pendingMarkdownContent = null;
            pendingSourceUrl = null;
            
            sendResponse({ 
                content: content,
                sourceUrl: url,
                fileName: fileName,
                startInPreview: startInPreview
            });
        });
        return true;
    }
    
    if (request.action === 'saveSettings') {
        // Save extension settings
        chrome.storage.local.set(request.settings, () => {
            sendResponse({ success: true });
        });
        return true;
    }
    
    if (request.action === 'getSettings') {
        // Get extension settings
        chrome.storage.local.get(['theme', 'fontSize', 'autoSave'], (result) => {
            sendResponse({ 
                settings: {
                    theme: result.theme || 'light',
                    fontSize: result.fontSize || '16px',
                    autoSave: result.autoSave !== false
                }
            });
        });
        return true;
    }
    
    // Default response
    sendResponse({ success: false, error: 'Unknown action' });
    return true;
});

// Handle tab updates to inject content script if needed
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.status === 'complete' && tab.url) {
        // Check if it's a markdown file
        if (tab.url.endsWith('.md') || tab.url.endsWith('.markdown')) {
            // Content script should already be injected via manifest
            console.log('Markdown file detected:', tab.url);
        }
    }
});

// Keep service worker alive
const keepAlive = () => {
    // Simple keep-alive ping
    chrome.runtime.getPlatformInfo(() => {
        // Just to keep the service worker active
    });
};

// Set up periodic keep-alive (every 20 seconds)
setInterval(keepAlive, 20000);

console.log('Techie Mark Down Manager background worker initialized');