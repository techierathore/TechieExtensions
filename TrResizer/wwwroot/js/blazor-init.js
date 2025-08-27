// Initialize Blazor in extension context
window.addEventListener('DOMContentLoaded', async () => {
    // Add reload button handler
    const reloadBtn = document.getElementById('reload-btn');
    if (reloadBtn) {
        reloadBtn.addEventListener('click', (e) => {
            e.preventDefault();
            location.reload();
        });
    }
    
    try {
        // Wait a bit for resources to load
        await new Promise(resolve => setTimeout(resolve, 100));
        
        await Blazor.start({
            loadBootResource: function (type, name, defaultUri, integrity) {
                // Fix paths for extension context
                const extensionUri = defaultUri.replace('/_framework/', '/blazor-framework/');
                return extensionUri;
            }
        });
    } catch (error) {
        console.error('Blazor initialization error:', error);
        const errorElement = document.getElementById('blazor-error-ui');
        if (errorElement) {
            errorElement.style.display = 'block';
        }
    }
});