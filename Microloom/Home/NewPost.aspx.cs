using System;
using System.Data;
using System.Web;
using System.Web.UI;

namespace MicroLoom.Home
{
    public partial class NewPost : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                lbl_username.Text = "Posting on @" + get_current_username() + "'s wall";
            }
        }

        protected void btn_post_Click(object sender, EventArgs e)
        {
            ConnectionClass ob = new ConnectionClass();
            string formattedDateTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
            string post = txt_post.Text.ToString();
            post = post.Replace("\n", "<br />");

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "new_post";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@u_id", Convert.ToInt32(Session["current_user"].ToString()));
                ob._sqlCommand.Parameters.AddWithValue("@post", post);
                ob._sqlCommand.Parameters.AddWithValue("@post_time", formattedDateTime);
                int t = ob._sqlCommand.ExecuteNonQuery();

                if (t == 1)
                {
                    Response.Redirect("Home.aspx");
                }

                else
                {
                    ShowAlertMessage("An error occurred!");
                }
            }

            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());
            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        private static void ShowAlertMessage(string error)
        {
            Page page = HttpContext.Current.Handler as Page;
            if (page != null)
            {
                error = error.Replace("'", "\'");
                ScriptManager.RegisterStartupScript(page, page.GetType(), "err_msg", "alert('" + error + "');", true);
            }
        }

        string get_current_username()
        {
            ConnectionClass con = new ConnectionClass();
            string username = string.Empty;

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT username from users WHERE u_id = " + Convert.ToInt32(Session["current_user"].ToString());
                con._sqlCommand.CommandType = CommandType.Text;
                var result = con._sqlCommand.ExecuteScalar();
                if (result != null)
                {
                    username = result.ToString(); // Get the username from the query result
                }
            }

            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
            }

            return username;
        }
    }
}