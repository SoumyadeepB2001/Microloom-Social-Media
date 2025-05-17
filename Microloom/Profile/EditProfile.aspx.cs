using System;
using System.Data.SqlClient;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web;

namespace MicroLoom.Profile
{
    public partial class EditProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {            
            handle_file_change();
            long u_id = Convert.ToInt64(Session["current_user"].ToString());

            if (!Page.IsPostBack)
                getInfo(u_id);
        }

        void handle_file_change()
        {
            string script = "function handleFileChange() { document.getElementById('" + btn_upload.ClientID + "').click(); }";
            ClientScript.RegisterStartupScript(this.GetType(), "handleFileChange", script, true);
        }

        void getInfo(long u_id)
        {
            ConnectionClass con = new ConnectionClass();
            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT u_id, email, username, full_name, profile_pic, bio, gender, location FROM users WHERE u_id = " + u_id;
                con._sqlCommand.CommandType = CommandType.Text;

                SqlDataReader sdr = con._sqlCommand.ExecuteReader();

                while (sdr.Read())
                {
                    lbl_user_id.Text = sdr["u_id"].ToString();
                    img_profile_pic.ImageUrl = sdr["profile_pic"].ToString();
                    lbl_old_profile_pic.Text = sdr["profile_pic"].ToString();
                    txt_full_name.Text = sdr["full_name"].ToString();
                    txt_bio.Text = sdr["bio"].ToString();
                    txt_email.Text = sdr["email"].ToString();
                    txt_location.Text = sdr["location"].ToString();

                    string gender = sdr["gender"].ToString();
                    if (gender == "Male")
                        ddl_gender.SelectedIndex = 0;
                    else if (gender == "Female")
                        ddl_gender.SelectedIndex = 1;
                    else
                        ddl_gender.SelectedIndex = 2;

                    break;
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
        }

        protected void btn_upload_Click(object sender, EventArgs e)
        {
            //Profile Picture naming convention: pic_{user_id}

            if (lbl_old_profile_pic.Text.ToString() != "/ProfilePictures/default_pic.jpg")
            {
                string old_path = Server.MapPath(lbl_old_profile_pic.Text.ToString());
                FileInfo file = new FileInfo(old_path);

                if (file.Exists)//check if the photo exists or not             
                    file.Delete();
            }

            string newFileName = "pic_" + Session["current_user"].ToString();
            string newFileExtension = System.IO.Path.GetExtension(profile_pic_upload.FileName);
            string newFilePath = "/ProfilePictures/" + newFileName + newFileExtension;

            profile_pic_upload.SaveAs(Server.MapPath(newFilePath));

            //Debug.WriteLine(newFileName + newFileExtension);

            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "UPDATE users SET profile_pic = '" + newFilePath + "' WHERE u_id = " + Session["current_user"].ToString();
                con._sqlCommand.CommandType = CommandType.Text;

                int t = con._sqlCommand.ExecuteNonQuery();

                if (t > 0)
                    img_profile_pic.ImageUrl = newFilePath;
            }

            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
                lbl_old_profile_pic.Text = newFilePath;
            }
        }

        protected void btn_del_profile_pic_Click(object sender, EventArgs e)
        {
            if (lbl_old_profile_pic.Text.ToString() != "/ProfilePictures/default_pic.jpg")
            {
                string old_path = Server.MapPath(lbl_old_profile_pic.Text.ToString());
                FileInfo file = new FileInfo(old_path);

                if (file.Exists) //check if the photo exists or not             
                    file.Delete();

                ConnectionClass con = new ConnectionClass();
                try
                {
                    con.CreateConnection();
                    con.OpenConnection();
                    con._sqlCommand.CommandText = "UPDATE users SET profile_pic = '/ProfilePictures/default_pic.jpg' WHERE u_id = " + Session["current_user"].ToString();
                    con._sqlCommand.CommandType = CommandType.Text;

                    int t = con._sqlCommand.ExecuteNonQuery();

                    if (t > 0)
                        img_profile_pic.ImageUrl = "/ProfilePictures/default_pic.jpg";
                }

                catch (Exception ex)
                {
                    Debug.WriteLine(ex.ToString());
                }

                finally
                {
                    con.CloseConnection();
                    con.DisposeConnection();
                    lbl_old_profile_pic.Text = "/ProfilePictures/default_pic.jpg";
                }
            }
        }

        protected void btn_update_Click(object sender, EventArgs e)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "update_details";
                con._sqlCommand.CommandType = CommandType.StoredProcedure;

                con._sqlCommand.Parameters.AddWithValue("@u_id", Session["current_user"].ToString());
                con._sqlCommand.Parameters.AddWithValue("@email", txt_email.Text.ToString());
                con._sqlCommand.Parameters.AddWithValue("@full_name", txt_full_name.Text.ToString());
                con._sqlCommand.Parameters.AddWithValue("@bio", txt_bio.Text.ToString());
                con._sqlCommand.Parameters.AddWithValue("@gender", ddl_gender.SelectedValue.ToString());
                con._sqlCommand.Parameters.AddWithValue("@loc", txt_location.Text.ToString());

                con._sqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
                Response.Redirect(Request.RawUrl);
            }
        }

        protected void btn_cancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
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

        bool validatePasswords()
        {
            string passwordPattern = @"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$"; // 8-10 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char

            string current_pass = txt_current_pass.Text.Trim();
            string new_pass = txt_new_pass.Text.Trim();

            // Ensure passwords are within valid length
            if (current_pass.Length < 8 || current_pass.Length > 10)
            {
                ShowAlertMessage("Current password must be between 8 and 10 characters long.");
                return false;
            }

            if (new_pass.Length < 8 || new_pass.Length > 10)
            {
                ShowAlertMessage("New password must be between 8 and 10 characters long.");
                return false;
            }

            // Validate new password complexity
            if (!Regex.IsMatch(new_pass, passwordPattern))
            {
                ShowAlertMessage("New password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.");
                return false;
            }

            return true;
        }

        protected void btn_change_pass_Click(object sender, EventArgs e)
        {
            if (!validatePasswords())
                return;


            string current_pass = txt_current_pass.Text.ToString().Trim();
            string current_hashed_pass = string.Empty;
            string new_pass = txt_new_pass.Text.ToString().Trim();
            string new_hashed_pass = string.Empty;
            long u_id = Convert.ToInt64(Session["current_user"].ToString());

            ConnectionClass con = new ConnectionClass();

            PasswordHasher hasher = new PasswordHasher();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT pass FROM users WHERE u_id = @u_id";
                con._sqlCommand.CommandType = CommandType.Text;
                con._sqlCommand.Parameters.AddWithValue("@u_id", u_id);

                SqlDataReader sdr = con._sqlCommand.ExecuteReader();

                while (sdr.Read())
                {
                    current_hashed_pass = sdr["pass"].ToString();
                }

                sdr.Close();
                con._sqlCommand.Parameters.Clear();

                if (hasher.VerifyPassword(current_hashed_pass, current_pass))
                {
                    new_hashed_pass = hasher.HashPassword(new_pass);

                    con._sqlCommand.CommandText = "UPDATE users SET pass = @new_pass WHERE u_id = @u_id";
                    con._sqlCommand.CommandType = CommandType.Text;
                    con._sqlCommand.Parameters.AddWithValue("@new_pass", new_hashed_pass);
                    con._sqlCommand.Parameters.AddWithValue("@u_id", u_id);

                    int t = con._sqlCommand.ExecuteNonQuery();

                    if (t == 1)
                    {
                        ShowAlertMessage("Password Changed Successfully");
                        txt_current_pass.Text = string.Empty;
                        txt_new_pass.Text = string.Empty;
                    }
                }

                else
                {
                    ShowAlertMessage("Enter the correct password");
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
        }

        protected void btn_delete_account_Click(object sender, EventArgs e)
        {
            btn_delete_account.Visible = false;
            btn_yes.Visible = true;
            btn_no.Visible = true;
            lbl_confirm.Visible = true;
        }

        protected void btn_no_Click(object sender, EventArgs e)
        {
            btn_delete_account.Visible = true;
            btn_yes.Visible = false;
            btn_no.Visible = false;
            lbl_confirm.Visible = false;
        }

        protected void btn_yes_Click(object sender, EventArgs e)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "DeleteUser";
                con._sqlCommand.CommandType = CommandType.StoredProcedure;

                con._sqlCommand.Parameters.AddWithValue("@user_id", Session["current_user"].ToString());

                con._sqlCommand.ExecuteNonQuery();

                logOut();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
            }

            finally
            {
                con.CloseConnection();
                con.DisposeConnection();
                
            }
        }

        void logOut()
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
