using Blazor.BrowserExtension;
using WebExtensions.Net.Runtime;
using System.Text.Json;

namespace TrJsonManager
{
    public partial class BackgroundWorker : BackgroundWorkerBase
    {
        private static string? pendingJsonContent = null;
        
        [BackgroundWorkerMain]
        public override void Main()
        {
            WebExtensions.Runtime.OnInstalled.AddListener(OnInstalled);
            WebExtensions.Runtime.OnMessage.AddListener(OnMessage);
        }

        async Task OnInstalled()
        {
            var indexPageUrl = WebExtensions.Runtime.GetURL("index.html");
            await WebExtensions.Tabs.Create(new()
            {
                Url = indexPageUrl
            });
        }
        
        async Task<object?> OnMessage(object message, MessageSender sender)
        {
            try
            {
                var jsonString = message?.ToString();
                if (string.IsNullOrEmpty(jsonString))
                    return new { success = false, error = "Empty message" };

                var msg = JsonSerializer.Deserialize<JsonElement>(jsonString);
                
                if (msg.TryGetProperty("action", out var actionProp) && 
                    actionProp.GetString() == "openJsonEditor")
                {
                    // Store the content temporarily
                    if (msg.TryGetProperty("content", out var contentProp))
                    {
                        pendingJsonContent = contentProp.GetString();
                    }
                    
                    // Open the editor in a new tab
                    var editorUrl = WebExtensions.Runtime.GetURL("index.html");
                    if (!string.IsNullOrEmpty(pendingJsonContent))
                    {
                        editorUrl += "?hasContent=true";
                    }
                    
                    await WebExtensions.Tabs.Create(new()
                    {
                        Url = editorUrl
                    });
                    
                    return new { success = true };
                }
                else if (msg.TryGetProperty("action", out var action2) && 
                         action2.GetString() == "getJsonContent")
                {
                    // Return the pending content and clear it
                    var content = pendingJsonContent;
                    pendingJsonContent = null;
                    return new { content = content };
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error handling message: {ex.Message}");
                return new { success = false, error = ex.Message };
            }
            
            return new { success = false, error = "Unknown action" };
        }
    }
}
