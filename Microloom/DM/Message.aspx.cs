using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.WebControls;

namespace MicroLoom.DM
{
    public partial class Message : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                long current_user_id = Convert.ToInt32(Session["current_user"].ToString());
                load_chatList(current_user_id);
            }
        }

        void load_chatList(long current_user_id)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT username from users WHERE u_id IN (SELECT following_id FROM follows WHERE follower_id = " + current_user_id + ")";
                con._sqlCommand.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(con._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                friends_list.DataSource = ds;
                friends_list.DataBind();
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

        void filter_chatList(long current_user_id, string search_string)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();

                con._sqlCommand.CommandText = "SELECT username FROM users WHERE u_id IN (SELECT following_id FROM follows WHERE follower_id = @FollowerID) AND username LIKE @SearchString";
                con._sqlCommand.CommandType = CommandType.Text;

                // Add parameters to prevent SQL injection
                con._sqlCommand.Parameters.AddWithValue("@FollowerID", current_user_id);
                con._sqlCommand.Parameters.AddWithValue("@SearchString", "%" + search_string + "%"); // Wildcard for partial matching

                SqlDataAdapter sda = new SqlDataAdapter(con._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);

                friends_list.DataSource = ds;
                friends_list.DataBind();
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

        protected void btn_followings_Click(object sender, EventArgs e)
        {
            RepeaterItem item = (sender as Button).Parent as RepeaterItem;
            Button chat = (Button)item.FindControl("btn_followings");
            string chat_name = chat.Text;
            string current_user = get_current_username();
            int result = String.Compare(chat_name, current_user);
            div_chat_area.Attributes.Remove("hidden");
            if (result < 0)
            {
                chat_group_name.Value = chat_name + "+" + current_user;
            }

            else if (result > 0)
            {
                chat_group_name.Value = current_user + "+" + chat_name;
            }
            current_username.Value = current_user;
            lbl_chat_name.Text = "Chatting with @" + chat_name;
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

        protected void btn_clr_Click(object sender, EventArgs e)
        {
            searchBox.Text = string.Empty;
            long current_user_id = Convert.ToInt32(Session["current_user"].ToString());
            load_chatList(current_user_id);
        }

        protected void btn_search_Click(object sender, EventArgs e)
        {
            long current_user_id = Convert.ToInt32(Session["current_user"].ToString());
            string search_string = searchBox.Text;
            filter_chatList(current_user_id, search_string);
        }
    }
}