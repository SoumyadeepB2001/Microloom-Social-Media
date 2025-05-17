using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Configuration;

namespace MicroLoom.Login
{
    public partial class login_registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                // Redirect to a different page if the user is already logged in
                Response.Redirect("/Home/Home.aspx");
            }

            if(!IsPostBack)
            {
                login_panel.Visible = true;
                register_panel.Visible = false;

                Title = "Log-in";
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

        protected void log_in_Click(object sender, EventArgs e)
        {
            login_panel.Visible = true;
            register_panel.Visible = false;

            Title = "Log-in";
        }

        protected void register_Click(object sender, EventArgs e)
        {
            login_panel.Visible = false;
            register_panel.Visible = true;

            Title = "Register";
        }
        void user_log_in(string username, string password)
        {
            ConnectionClass con = new ConnectionClass();
            int flag = 0;
            string storedPass = string.Empty;
            string currentUser = string.Empty;

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "validate_users";
                con._sqlCommand.CommandType = CommandType.StoredProcedure;

                con._sqlCommand.Parameters.AddWithValue("@username", username);

                SqlDataReader sdr = con._sqlCommand.ExecuteReader();

                while (sdr.Read())
                {
                    flag++;
                    storedPass = sdr["pass"].ToString();
                    currentUser = sdr["u_id"].ToString();
                }

                if (flag == 0)
                {
                    ShowAlertMessage("Username not found");
                    return;
                }

                else if (flag == 1)
                {
                    PasswordHasher ps = new PasswordHasher();

                    if (ps.VerifyPassword(storedPass, password))
                    {
                        Session["current_user"] = currentUser;
                        FormsAuthentication.SetAuthCookie(username, true);
                        string redirectUrl = FormsAuthentication.GetRedirectUrl(username, true);
                        Response.Redirect(redirectUrl, false);
                    }

                    else
                    {
                        ShowAlertMessage("Wrong Password!");
                        return;
                    }
                }

                else
                {
                    ShowAlertMessage("Invalid Credentials");
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

        protected void btn_register_Click(object sender, EventArgs e)
        {
            if (!validateRegForm())
                return;

            string user_name = reg_username.Text.Trim();
            string full_name = reg_fullname.Text.Trim();
            string email = reg_email.Text.Trim();

            PasswordHasher ps = new PasswordHasher();
            string password = ps.HashPassword(reg_password.Text.Trim().ToString());

            ConnectionClass ob = new ConnectionClass();

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "check_user_existence";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@username", user_name);
                ob._sqlCommand.Parameters.AddWithValue("@email", email);

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
                else if (result == 0)
                {
                    if (send_otp(email))
                    {
                        Session["user_name"] = user_name;
                        Session["full_name"] = full_name;
                        Session["email"] = email;
                        Session["password"] = password;

                        Response.Redirect("/Login/registration_otp.aspx");
                    }

                    else
                        ShowAlertMessage("An error occured while sending OTP");
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

        bool send_otp(string email_to)
        {
            string email_from = ConfigurationManager.AppSettings["EmailFrom"]; //Your email address from web.config
            string appPassword = ConfigurationManager.AppSettings["EmailPassword"]; //Your email password from web.config
            string otp;

            Random rnd = new Random();
            otp = rnd.Next(100000, 999999).ToString(); // Generates a 6-digit OTP

            Session["reg_otp"] = otp;

            try
            {
                MailMessage message = new MailMessage(email_from, email_to)
                {
                    Subject = "Welcome to Microloom",
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

        bool validateRegForm()
        {
            string username = reg_username.Text.Trim();
            string fullname = reg_fullname.Text.Trim();
            string email = reg_email.Text.Trim();
            string password = reg_password.Text;

            // Regex patterns for validation
            string usernamePattern = @"^[A-Za-z][A-Za-z0-9_]*$"; // Username must start with a letter and contain only letters, numbers, or underscores
            string fullnamePattern = @"^[A-Za-z\s]+$"; // Full name must contain only letters and spaces
            string emailPattern = @"^[^\s@]+@[^\s@]+\.[^\s@]+$"; // Basic email validation
            string passwordPattern = @"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$"; // 8-10 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char

            // Username length validation
            if (username.Length < 3 || username.Length > 15)
            {
                ShowAlertMessage("Username must be between 3 and 15 characters long.");
                return false;
            }

            if (!Regex.IsMatch(username, usernamePattern))
            {
                ShowAlertMessage("Username must start with a letter and can only contain letters, numbers, and underscores.");
                return false;
            }

            if (!Regex.IsMatch(fullname, fullnamePattern))
            {
                ShowAlertMessage("Full name should contain only letters and spaces.");
                return false;
            }

            if (!Regex.IsMatch(email, emailPattern))
            {
                ShowAlertMessage("Please enter a valid email address.");
                return false;
            }

            // Password length validation
            if (password.Length < 8 || password.Length > 10)
            {
                ShowAlertMessage("Password must be between 8 and 10 characters long.");
                return false;
            }

            if (!Regex.IsMatch(password, passwordPattern))
            {
                ShowAlertMessage("Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.");
                return false;
            }

            return true;
        }


        protected void btn_login_Click(object sender, EventArgs e)
        {
            string username = login_username.Text.ToString();
            string password = login_password.Text.ToString();
            user_log_in(username, password);
        }

        protected void forgot_pass_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Login/forgot_password.aspx");
        }
    }
}
