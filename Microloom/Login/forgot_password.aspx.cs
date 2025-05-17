using System;
using System.Data;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Configuration;

namespace MicroLoom.Login
{
    public partial class forgot_password : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                // Redirect to a different page if the user is already logged in
                Response.Redirect("/Home/Home.aspx");
            }

            if (!IsPostBack)
            {
                otp_panel.Visible = true;
                update_password_panel.Visible = false;
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

        protected void btn_change_pass_Click(object sender, EventArgs e)
        {
            string entered_otp = txt_otp.Text.ToString().Trim();
            string actual_otp = Session["otp"].ToString().Trim();
            string confirm_pass = txt_confirm_password.Text.ToString().Trim();
            string new_pass = txt_new_password.Text.ToString().Trim();
            string email = Session["user_email"].ToString().Trim();

            if (Session["otp"] == null || Session["user_email"] == null)
            {
                ShowAlertMessage("Session expired. Please try again.");
                return;
            }

            if (entered_otp != actual_otp)
            {
                ShowAlertMessage("Wrong OTP");
                return;
            }

            if (confirm_pass != new_pass)
            {
                ShowAlertMessage("Passwords do not match");
                return;
            }

            string passwordPattern = @"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$";
            if (!System.Text.RegularExpressions.Regex.IsMatch(new_pass, passwordPattern))
            {
                ShowAlertMessage("Password must be 8-10 characters long and contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.");
                return;
            }

            ConnectionClass con = new ConnectionClass();
            PasswordHasher ps = new PasswordHasher();
            try
            {
                string new_hashed_pass = ps.HashPassword(new_pass);
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "UPDATE users SET pass = @new_pass WHERE email = @email";
                con._sqlCommand.CommandType = CommandType.Text;
                con._sqlCommand.Parameters.AddWithValue("@new_pass", new_hashed_pass);
                con._sqlCommand.Parameters.AddWithValue("@email", email);

                int t = con._sqlCommand.ExecuteNonQuery();

                if (t == 1)
                {
                    Response.Redirect("/Login/login_registration.aspx");
                }
            }

            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());

            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
            }
        }

        protected void btn_send_otp_Click(object sender, EventArgs e)
        {
            string query = txt_username_email.Text.ToString().Trim();
            string email = String.Empty;

            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT email FROM users WHERE email = @query or username = @query";
                con._sqlCommand.CommandType = CommandType.Text;
                con._sqlCommand.Parameters.AddWithValue("@query", query);

                object result = con._sqlCommand.ExecuteScalar();

                if (result != null)
                    email = result.ToString(); // Get the email

                if (send_otp(email))
                {
                    otp_panel.Visible = false;
                    update_password_panel.Visible = true;
                }

                else
                    ShowAlertMessage("An error occurred!");

            }

            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.ToString());

            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
            }
        }

        bool send_otp(string email_to)
        {
            string email_from = ConfigurationManager.AppSettings["EmailFrom"]; //Your email address from web.config
            string appPassword = ConfigurationManager.AppSettings["EmailPassword"]; //Your email password from web.config
            string otp;

            Random rnd = new Random();
            otp = rnd.Next(100000, 999999).ToString(); // Generates a 6-digit OTP

            Session["otp"] = otp;
            Session["user_email"] = email_to;

            try
            {
                MailMessage message = new MailMessage(email_from, email_to)
                {
                    Subject = "OTP for password change",
                    Body = "Your OTP is: " + otp,
                    BodyEncoding = Encoding.UTF8,
                    IsBodyHtml = true
                };

                SmtpClient client = new SmtpClient("smtp.gmail.com", 587)
                {
                    EnableSsl = true,
                    UseDefaultCredentials = false,
                    Credentials = new NetworkCredential(email_from, appPassword)
                };

                client.Send(message);
                return true; // OTP sent successfully
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString()); // Log the error for debugging
                return false; // OTP sending failed
            }
        }
    }
}
