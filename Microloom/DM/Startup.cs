using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(MicroLoom.DM.Startup))]

namespace MicroLoom.DM
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}
