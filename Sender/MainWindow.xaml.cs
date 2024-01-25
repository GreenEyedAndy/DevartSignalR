using System.ComponentModel;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Documents.Serialization;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Newtonsoft.Json;

namespace Sender;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private IHost host;
    
    public MainWindow()
    {
        InitializeComponent();
        StartHost().GetAwaiter().GetResult();
    }

    private async Task StartHost()
    {
        host = Host.CreateDefaultBuilder()
            .ConfigureWebHostDefaults(builder => builder
                .UseUrls("http://localhost:5100")
                .ConfigureServices(collection => collection.AddSignalR())
                .Configure(applicationBuilder =>
                {
                    applicationBuilder.UseRouting();
                    applicationBuilder.UseEndpoints(routeBuilder => routeBuilder.MapHub<MessageHub>("/messageHub"));
                })
            )
            .Build();

        await host.StartAsync();
    }

    private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
    {
        var hubContext = host.Services.GetRequiredService<IHubContext<MessageHub>>();
        TestObject test = new TestObject { Message = "äöü_ABCDEF_123" };
        var json = JsonConvert.SerializeObject(test);
        hubContext.Clients.All.SendAsync("ChangedEntities", json);  // <-- this was decoded right
        hubContext.Clients.All.SendAsync("ChangedEntities", test);  // <-- this was decoded with something missing
    }

    private void MainWindow_OnClosing(object? sender, CancelEventArgs e)
    {
        host?.Dispose();
    }
}

public class MessageHub : Hub
{
}

public class TestObject
{
    public string Message { get; set; }
}