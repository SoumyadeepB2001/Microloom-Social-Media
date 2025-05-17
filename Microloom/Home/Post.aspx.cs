using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MicroLoom.Home
{
    public partial class Post : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string postId = Request.QueryString["p_id"];

                if (string.IsNullOrEmpty(postId))
                {
                    Response.Redirect("~/Error.aspx");
                    return;
                }

                if (!int.TryParse(postId, out int userIdInt))
                {
                    Response.Redirect("~/Error.aspx");
                    return;
                }
            
                load_posts();
                load_comments();
            }
        }

        protected void post_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label label_like_text = (Label)e.Item.FindControl("lbl_like_text");
                Button like_btn = (Button)e.Item.FindControl("btn_like");
                Button dislike_btn = (Button)e.Item.FindControl("btn_dislike");

                Label label_share_text = (Label)e.Item.FindControl("lbl_share_text");
                Button share_btn = (Button)e.Item.FindControl("btn_share");

                string like_text = label_like_text.Text;
                string share_text = label_share_text.Text;

                if (like_text == "Liked")
                {
                    like_btn.BackColor = System.Drawing.Color.FromArgb(80, 60, 160);
                    like_btn.Text = "Liked 👍";
                }

                else if (like_text == "Disliked")
                {
                    dislike_btn.BackColor = System.Drawing.Color.Red;
                    dislike_btn.Text = "Disliked 👎";
                }

                if (share_text == "Shared")
                {
                    share_btn.BackColor = System.Drawing.Color.Green;
                    share_btn.Text = "Shared ↩️";
                }
            }
        }

        string[] reactions(long u_id, long p_id, string status)
        {
            ConnectionClass ob = new ConnectionClass();

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "add_remove_reaction";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@u_id", u_id);
                ob._sqlCommand.Parameters.AddWithValue("@p_id", p_id);
                ob._sqlCommand.Parameters.AddWithValue("@status", status);

                SqlDataReader sdr = ob._sqlCommand.ExecuteReader();
                sdr.Read();

                String[] result = new String[5];

                result[0] = Convert.ToString(sdr["likes"]);
                result[1] = Convert.ToString(sdr["dislikes"]);
                result[2] = Convert.ToString(sdr["comments"]);
                result[3] = Convert.ToString(sdr["shares"]);
                result[4] = Convert.ToString(sdr["LikeText"]);

                return result;

            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
                return null;
            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        string[] shares(long u_id, long p_id)
        {
            ConnectionClass ob = new ConnectionClass();

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "add_remove_share";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@u_id", u_id);
                ob._sqlCommand.Parameters.AddWithValue("@p_id", p_id);

                SqlDataReader sdr = ob._sqlCommand.ExecuteReader();
                sdr.Read();

                String[] result = new String[5];

                result[0] = Convert.ToString(sdr["likes"]);
                result[1] = Convert.ToString(sdr["dislikes"]);
                result[2] = Convert.ToString(sdr["comments"]);
                result[3] = Convert.ToString(sdr["shares"]);
                result[4] = Convert.ToString(sdr["ShareText"]);

                return result;

            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
                return null;
            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        protected void btn_like_Click(object sender, EventArgs e)
        {
            try
            {
                RepeaterItem item = (sender as Button).Parent as RepeaterItem;

                Label likeText = (Label)item.FindControl("lbl_like_text");
                Label post_id = (Label)item.FindControl("lbl_p_id");

                long p_id = Convert.ToInt64(post_id.Text);
                long user_id = Convert.ToInt32(Session["current_user"].ToString());
                string status = "";

                if (likeText.Text.ToString() == "Liked")
                {
                    status = "remove_like";
                }

                else if (likeText.Text.ToString() == "Disliked")
                {
                    status = "dislike_to_like";
                }

                else if (likeText.Text.ToString() == "null")
                {
                    status = "add_like";
                }

                string[] result = reactions(user_id, p_id, status);
                Button like_btn = (Button)item.FindControl("btn_like");
                Button dislike_btn = (Button)item.FindControl("btn_dislike");

                likeText.Text = result[4].ToString();

                if (result[4] == "Liked")
                {
                    like_btn.BackColor = System.Drawing.Color.FromArgb(80, 60, 160);
                    like_btn.Text = "Liked 👍";

                    dislike_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    dislike_btn.Text = "Dislike 👎";
                }

                else if (result[4] == "null")
                {
                    like_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    like_btn.Text = "Like 👍";

                    dislike_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    dislike_btn.Text = "Dislike 👎";
                }

                Label likes = (Label)item.FindControl("lbl_no_likes");
                Label dislikes = (Label)item.FindControl("lbl_dislikes");
                Label replies = (Label)item.FindControl("lbl_no_replies");
                Label shares = (Label)item.FindControl("lbl_no_shares");

                likes.Text = result[0].ToString().Trim() + " likes | ";
                dislikes.Text = result[1].ToString().Trim() + " dislikes | ";
                replies.Text = result[2].ToString().Trim() + " replies | ";
                shares.Text = result[3].ToString().Trim() + " shares | ";
            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }
        }

        protected void btn_dislike_Click(object sender, EventArgs e)
        {
            try
            {
                RepeaterItem item = (sender as Button).Parent as RepeaterItem;

                Label likeText = (Label)item.FindControl("lbl_like_text");
                Label post_id = (Label)item.FindControl("lbl_p_id");

                long p_id = Convert.ToInt64(post_id.Text);
                long user_id = Convert.ToInt32(Session["current_user"].ToString());
                string status = "";

                if (likeText.Text.ToString() == "Liked")
                {
                    status = "like_to_dislike";
                }

                else if (likeText.Text.ToString() == "Disliked")
                {
                    status = "remove_dislike";
                }

                else if (likeText.Text.ToString() == "null")
                {
                    status = "add_dislike";
                }

                string[] result = reactions(user_id, p_id, status);
                Button like_btn = (Button)item.FindControl("btn_like");
                Button dislike_btn = (Button)item.FindControl("btn_dislike");

                likeText.Text = result[4].ToString();

                if (result[4] == "Disliked")
                {
                    dislike_btn.BackColor = System.Drawing.Color.Red;
                    dislike_btn.Text = "Disliked 👎";

                    like_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    like_btn.Text = "Like 👍";
                }

                else if (result[4] == "null")
                {
                    like_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    like_btn.Text = "Like 👍";

                    dislike_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    dislike_btn.Text = "Dislike 👎";
                }

                Label likes = (Label)item.FindControl("lbl_no_likes");
                Label dislikes = (Label)item.FindControl("lbl_dislikes");
                Label replies = (Label)item.FindControl("lbl_no_replies");
                Label shares = (Label)item.FindControl("lbl_no_shares");

                likes.Text = result[0].ToString().Trim() + " likes | ";
                dislikes.Text = result[1].ToString().Trim() + " dislikes | ";
                replies.Text = result[2].ToString().Trim() + " replies | ";
                shares.Text = result[3].ToString().Trim() + " shares | ";
            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }
        }

        protected void btn_share_Click(object sender, EventArgs e)
        {
            try
            {
                RepeaterItem item = (sender as Button).Parent as RepeaterItem;

                Label shareText = (Label)item.FindControl("lbl_share_text");
                Label post_id = (Label)item.FindControl("lbl_p_id");

                long p_id = Convert.ToInt64(post_id.Text);
                long user_id = Convert.ToInt32(Session["current_user"].ToString());

                string[] result = shares(user_id, p_id);

                Label likes = (Label)item.FindControl("lbl_no_likes");
                Label dislikes = (Label)item.FindControl("lbl_dislikes");
                Label replies = (Label)item.FindControl("lbl_no_replies");
                Label share = (Label)item.FindControl("lbl_no_shares");

                likes.Text = result[0].ToString().Trim() + " likes | ";
                dislikes.Text = result[1].ToString().Trim() + " dislikes | ";
                replies.Text = result[2].ToString().Trim() + " replies | ";
                share.Text = result[3].ToString().Trim() + " shares | ";

                shareText.Text = result[4].ToString().Trim();
                Button share_btn = (Button)item.FindControl("btn_share");

                if (result[4] == "Shared")
                {
                    share_btn.BackColor = System.Drawing.Color.Green;
                    share_btn.Text = "Shared ↩️";
                }

                else
                {
                    share_btn.BackColor = System.Drawing.Color.FromArgb(33, 33, 36);
                    share_btn.Text = "Share ↩️";
                }
            }

            catch (Exception ex)
            {

            }
        }

        void load_posts()
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_single_post";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@post_id", Convert.ToInt64(Server.UrlDecode(Request.QueryString["p_id"])));
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                
                if (ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
                {
                    // Redirect to error page or show a message
                    Response.Redirect("~/Error.aspx");
                    return;
                }
                
                post_repeater.DataSource = ds;
                post_repeater.DataBind();
            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        void load_comments()
        {
            long p_id = Convert.ToInt64(Server.UrlDecode(Request.QueryString["p_id"]));


            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_comments";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@p_id", Convert.ToInt64(Server.UrlDecode(Request.QueryString["p_id"])));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                comments_repeater.DataSource = ds;
                comments_repeater.DataBind();
            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        protected void btn_post_comment_Click(object sender, EventArgs e)
        {
            long p_id = Convert.ToInt64(Server.UrlDecode(Request.QueryString["p_id"]));
            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            string comment = txt_comment.Text.ToString();
            comment = comment.Replace("\n", "<br />");
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "add_comments";
                con._sqlCommand.CommandType = CommandType.StoredProcedure;
                con._sqlCommand.Parameters.AddWithValue("@p_id", p_id);
                con._sqlCommand.Parameters.AddWithValue("@u_id", u_id);
                con._sqlCommand.Parameters.AddWithValue("@comment", comment);

                int t = con._sqlCommand.ExecuteNonQuery();

                if (t > 0)
                    load_comments();
            }

            catch (Exception ex)
            {
                Response.Write(ex.ToString());
            }

            finally
            {
                txt_comment.Text = string.Empty;
                con.CloseConnection();
                con.DisposeConnection();
            }
        }
    }
}
