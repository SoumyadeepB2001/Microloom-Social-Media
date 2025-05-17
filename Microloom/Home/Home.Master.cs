using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace MicroLoom.Home
{
    public partial class Home : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_search_Click(object sender, EventArgs e)
        {
            txt_search.Visible = false;
            btn_search.Visible = false;
            btn_magnify.Visible = true;
            Response.Redirect("/Home/Search.aspx?search=" + txt_search.Text.ToString());
        }

        protected void btn_magnify_Click(object sender, ImageClickEventArgs e)
        {
            txt_search.Visible = true;
            btn_search.Visible = true;
            btn_magnify.Visible = false;
        }

        protected void Log_out_ServerClick(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            HttpCookie authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, "")
            {
                Expires = DateTime.Now.AddYears(-1)  
            };
            Response.Cookies.Add(authCookie);
            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", "")
            {
                Expires = DateTime.Now.AddYears(-1)
            };
            Response.Cookies.Add(sessionCookie);
            Response.Redirect("/Login/login_registration.aspx", false);
        }
    }
}
