using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace MicroLoom
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {
            if (HttpContext.Current.User != null && HttpContext.Current.User.Identity.IsAuthenticated)
            {
                int flag = 0;
                string username = HttpContext.Current.User.Identity.Name;
                ConnectionClass con = new ConnectionClass();
                string u_id = string.Empty;
                try
                {
                    con.CreateConnection();
                    con.OpenConnection();
                    con._sqlCommand.CommandText = "SELECT u_id FROM users WHERE username = @username";
                    con._sqlCommand.CommandType = CommandType.Text;
                    con._sqlCommand.Parameters.AddWithValue("@username", username);
                    SqlDataReader sdr = con._sqlCommand.ExecuteReader();

                    while (sdr.Read())
                    {
                        flag++;
                        u_id = sdr["u_id"].ToString();
                    }

                    if (flag == 1)
                    {
                        Session["current_user"] = u_id;
                    }
                }

                catch (Exception ex)
                {
                    Response.Write(ex.ToString());
                }

                finally
                {
                    con.CloseConnection();
                    con.DisposeConnection();
                }
            }
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}