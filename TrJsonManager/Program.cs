﻿using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using Blazor.BrowserExtension;
using TrJsonManager;
using TrJsonManager.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.UseBrowserExtension(browserExtension =>
{
    if (browserExtension.Mode == BrowserExtensionMode.Background)
    {
        builder.RootComponents.AddBackgroundWorker<BackgroundWorker>();
    }
    else
    {
        builder.RootComponents.Add<App>("#app");
        builder.RootComponents.Add<HeadOutlet>("head::after");
    }
});

builder.Services.AddScoped(sp => new HttpClient { BaseAddress = new Uri(builder.HostEnvironment.BaseAddress) });
builder.Services.AddScoped<IJsonService, JsonService>();

await builder.Build().RunAsync();
