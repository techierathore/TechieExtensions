// Editor helper functions for Markdown editor functionality

// Synchronize scrolling between two elements
window.syncScroll = function(sourceElement, targetElement, sourceType) {
    if (!sourceElement || !targetElement) {
        console.log('Sync scroll: Missing elements', sourceElement, targetElement);
        return;
    }
    
    // Calculate scroll percentage of source element
    const sourceScrollHeight = sourceElement.scrollHeight - sourceElement.clientHeight;
    if (sourceScrollHeight <= 0) {
        console.log('Source has no scrollable content');
        return;
    }
    
    const scrollPercentage = sourceElement.scrollTop / sourceScrollHeight;
    
    // Apply same percentage to target element
    const targetScrollHeight = targetElement.scrollHeight - targetElement.clientHeight;
    if (targetScrollHeight <= 0) {
        console.log('Target has no scrollable content');
        return;
    }
    
    const newScrollTop = Math.round(scrollPercentage * targetScrollHeight);
    targetElement.scrollTop = newScrollTop;
    
    console.log(`Sync from ${sourceType}: ${scrollPercentage * 100}% (${sourceElement.scrollTop}/${sourceScrollHeight}) -> ${newScrollTop}/${targetScrollHeight}`);
};

// Download markdown as file
window.downloadMarkdown = function(content, filename) {
    const blob = new Blob([content], { type: 'text/markdown;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename || 'document.md';
    link.click();
    URL.revokeObjectURL(url);
};