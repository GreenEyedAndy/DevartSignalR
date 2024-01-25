using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.AspNetCore.SignalR.Client;

namespace Client;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private HubConnection connection;
    
    public MainWindow()
    {
        InitializeComponent();

        connection = new HubConnectionBuilder()
            .WithUrl("http://localhost:5100/messageHub")
            .Build();

        connection.On<object>("ChangedEntities", (message) =>
        {
            this.Dispatcher.Invoke(() =>
            {
                TextBox.AppendText(message + Environment.NewLine);
            });
        });

        connection.StartAsync();
    }
}