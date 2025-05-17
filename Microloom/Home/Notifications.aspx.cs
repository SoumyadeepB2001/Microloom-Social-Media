using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;

namespace MicroLoom.Home
{
    public partial class Notifications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                int u_id = Convert.ToInt32(Session["current_user"].ToString());
                load_notifications(u_id);
            }
        }

        void load_notifications(int u_id)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();

                con._sqlCommand.CommandText = "SELECT notif_text, link FROM notifications WHERE u_id = @u_id ORDER BY notif_id DESC";
                con._sqlCommand.CommandType = CommandType.Text;
                con._sqlCommand.Parameters.AddWithValue("@u_id", u_id);

                SqlDataAdapter sda = new SqlDataAdapter(con._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);

                notifs_repeater.DataSource = ds;
                notifs_repeater.DataBind();
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
    }
}