// Simple sync scroll functionality
window.syncScroll = function(source, target) {
    if (!source || !target) return;
    
    // Calculate the scroll ratio
    var scrollRatio = source.scrollTop / (source.scrollHeight - source.clientHeight);
    
    // Apply the ratio to the target
    target.scrollTop = scrollRatio * (target.scrollHeight - target.clientHeight);
};