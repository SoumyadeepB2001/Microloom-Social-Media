using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;

namespace MicroLoom.DM
{
    public class ChatHub : Hub
    {
        public Task JoinPrivateChat(string chatGroupName)
        {
            return Groups.Add(Context.ConnectionId, chatGroupName);
        }

        // Method to leave a private chat group
        public Task LeavePrivateChat(string chatGroupName)
        {
            return Groups.Remove(Context.ConnectionId, chatGroupName);
        }

        // Send a message to a specific group
        public void SendPrivateMessage(string chatGroupName, string username, string message)
        {
            // Send the message to all users in the specified group
            Clients.Group(chatGroupName).broadcastMessage(username, message);
        }
    }
}
