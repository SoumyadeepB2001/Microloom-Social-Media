using System;
using System.Data;

namespace MicroLoom.Login
{
    public partial class registration_otp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                // Redirect to a different page if the user is already logged in
                Response.Redirect("/Home/Home.aspx");
            }

            if (Session["reg_otp"] == null || Session["email"] == null || Session["full_name"] == null || Session["user_name"] == null || Session["password"] == null)
            {
                ShowAlertMessage("Session expired. Please try again.");
                Response.Redirect("/Login/login_registration.aspx");
            }
        }

        private static void ShowAlertMessage(string error)
        {
            System.Web.UI.Page page = System.Web.HttpContext.Current.Handler as System.Web.UI.Page;
            if (page != null)
            {
                error = error.Replace("'", "\'");
                System.Web.UI.ScriptManager.RegisterStartupScript(page, page.GetType(), "err_msg", "alert('" + error + "');", true);
            }
        }

        protected void btn_register_Click(object sender, EventArgs e)
        {
            if (Session["reg_otp"].ToString() != txt_otp.Text.ToString())
            {
                ShowAlertMessage("Wrong OTP");
                return;
            }

            string user_name = Session["user_name"].ToString();
            string full_name = Session["full_name"].ToString();
            string email = Session["email"].ToString();
            string password = Session["password"].ToString();

            ConnectionClass ob = new ConnectionClass();

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "register_new_user";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@username", user_name);
                ob._sqlCommand.Parameters.AddWithValue("@full_name", full_name);
                ob._sqlCommand.Parameters.AddWithValue("@email", email);
                ob._sqlCommand.Parameters.AddWithValue("@pass", password);

                // Use ExecuteScalar() to get the return value
                int result = (int)ob._sqlCommand.ExecuteScalar();

                if (result == -1)
                {
                    ShowAlertMessage("Username already exists. Please choose a different username.");
                }
                else if (result == -2)
                {
                    ShowAlertMessage("Email is already registered. Please use a different email.");
                }
                else if (result == 1)
                {
                    Response.Redirect("/Login/login_registration.aspx");
                }
                else
                {
                    ShowAlertMessage("Registration failed. Please try again later.");
                }
            }
            catch (Exception ex)
            {
                ShowAlertMessage("Error: " + ex.Message);
            }
            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }
    }
}