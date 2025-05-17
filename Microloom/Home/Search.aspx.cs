using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;

namespace MicroLoom.Home
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string query_string = Server.UrlDecode(Request.QueryString["search"]).ToString();
                string current_user = Session["current_user"].ToString();
                search_accounts(query_string, current_user);
            }
        }

        void search_accounts(string query_string, string current_user)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT u_id, username, full_name, profile_pic, followers, followings, bio " +
                              "FROM users " +
                              "WHERE (username LIKE '%' + @query_string + '%' OR full_name LIKE '%' + @query_string + '%') " +
                              "AND u_id != @current_user";
                con._sqlCommand.CommandType = CommandType.Text;
                con._sqlCommand.Parameters.AddWithValue("@query_string", query_string);
                con._sqlCommand.Parameters.AddWithValue("@current_user", current_user);

                SqlDataAdapter sda = new SqlDataAdapter(con._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                int no_of_results = ds.Tables.Count > 0 ? ds.Tables[0].Rows.Count : 0;

                if (no_of_results == 0)
                {
                    lbl_search_message.Text = "No results were found";
                    return;
                }

                else if (no_of_results == 1)
                {
                    lbl_search_message.Text = "1 result was found";
                }

                else
                {
                    lbl_search_message.Text = no_of_results.ToString() + " results were found";
                }

                accounts_repeater.DataSource = ds;
                accounts_repeater.DataBind();

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
    }
}