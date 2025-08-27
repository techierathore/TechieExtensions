// Check if Chrome API is available
const browserAPI = (typeof chrome !== 'undefined' && chrome.windows) ? chrome : 
                  (typeof browser !== 'undefined' && browser.windows) ? browser : null;

// Get current window size
async function getCurrentWindowSize() {
    try {
        console.log('Getting current window size...');
        
        if (!browserAPI || !browserAPI.tabs || !browserAPI.windows) {
            console.error('Browser API not available');
            return { width: window.outerWidth || 1024, height: window.outerHeight || 768 };
        }
        
        const [tab] = await browserAPI.tabs.query({ active: true, currentWindow: true });
        console.log('Active tab:', tab);
        
        if (tab && tab.windowId) {
            const windowInfo = await browserAPI.windows.get(tab.windowId);
            console.log('Window info:', windowInfo);
            return { width: windowInfo.width, height: windowInfo.height };
        }
    } catch (error) {
        console.error('Error getting window size:', error);
        showStatus(`Error: ${error.message}`, true);
    }
    return { width: 1024, height: 768 };
}

// Resize window
async function resizeWindow(width, height) {
    try {
        console.log(`Attempting to resize window to ${width}x${height}`);
        
        if (!browserAPI || !browserAPI.tabs || !browserAPI.windows) {
            console.error('Browser API not available');
            showStatus('Browser API not available', true);
            return false;
        }
        
        const [tab] = await browserAPI.tabs.query({ active: true, currentWindow: true });
        console.log('Active tab for resize:', tab);
        
        if (tab && tab.windowId) {
            const result = await browserAPI.windows.update(tab.windowId, {
                width: parseInt(width),
                height: parseInt(height),
                state: 'normal' // Ensure window is not maximized or minimized
            });
            console.log('Resize result:', result);
            
            if (browserAPI.runtime.lastError) {
                console.error('Runtime error:', browserAPI.runtime.lastError);
                showStatus(`Error: ${browserAPI.runtime.lastError.message}`, true);
                return false;
            }
            
            return true;
        } else {
            console.error('No active tab found');
            showStatus('No active window found', true);
            return false;
        }
    } catch (error) {
        console.error('Error resizing window:', error);
        showStatus(`Error: ${error.message}`, true);
        return false;
    }
}

// Update current size display
async function updateCurrentSize() {
    const size = await getCurrentWindowSize();
    const sizeElement = document.getElementById('currentSize');
    if (sizeElement) {
        sizeElement.textContent = `${size.width} x ${size.height}`;
    }
}

// Show status message
function showStatus(message, isError = false) {
    const statusElement = document.getElementById('statusMessage');
    if (statusElement) {
        statusElement.textContent = message;
        statusElement.className = `status-message show ${isError ? 'error' : 'success'}`;
        
        // Hide after 3 seconds
        setTimeout(() => {
            statusElement.className = 'status-message';
        }, 3000);
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', async () => {
    console.log('Extension popup loaded');
    console.log('Browser API available:', !!browserAPI);
    
    // Update current size on load
    await updateCurrentSize();
    
    // Add event listeners to preset buttons
    const presetButtons = document.querySelectorAll('.btn[data-width]');
    presetButtons.forEach(button => {
        button.addEventListener('click', async () => {
            const width = button.getAttribute('data-width');
            const height = button.getAttribute('data-height');
            
            const success = await resizeWindow(width, height);
            if (success) {
                showStatus(`Window resized to ${width} x ${height}`);
                // Update display after a short delay
                setTimeout(updateCurrentSize, 100);
            } else {
                showStatus('Failed to resize window', true);
            }
        });
    });
    
    // Add event listener for custom size button
    const applyCustomButton = document.getElementById('applyCustom');
    if (applyCustomButton) {
        applyCustomButton.addEventListener('click', async () => {
            const widthInput = document.getElementById('customWidth');
            const heightInput = document.getElementById('customHeight');
            
            const width = parseInt(widthInput.value);
            const height = parseInt(heightInput.value);
            
            if (width < 100 || height < 100) {
                showStatus('Width and height must be at least 100 pixels', true);
                return;
            }
            
            if (width > 9999 || height > 9999) {
                showStatus('Width and height cannot exceed 9999 pixels', true);
                return;
            }
            
            const success = await resizeWindow(width, height);
            if (success) {
                showStatus(`Window resized to ${width} x ${height}`);
                // Update display after a short delay
                setTimeout(updateCurrentSize, 100);
            } else {
                showStatus('Failed to resize window', true);
            }
        });
    }
    
    // Add event listener for feedback button
    const feedbackButton = document.getElementById('feedbackBtn');
    if (feedbackButton) {
        feedbackButton.addEventListener('click', () => {
            // Open feedback form in new tab
            if (browserAPI && browserAPI.tabs) {
                browserAPI.tabs.create({
                    url: 'https://forms.gle/gctmvQ4bYv72PHRA9',
                    active: true
                });
            } else {
                window.open('https://forms.gle/gctmvQ4bYv72PHRA9', '_blank');
            }
        });
    }
    
    // Update size periodically
    setInterval(updateCurrentSize, 2000);
});