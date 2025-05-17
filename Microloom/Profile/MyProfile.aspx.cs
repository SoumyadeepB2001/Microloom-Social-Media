using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MicroLoom.Profile
{
    public partial class MyProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                long u_id = Convert.ToInt64(Session["current_user"].ToString());
                load_profile_info(u_id);
                load_posts(u_id);
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

        void load_profile_info(long user_id)
        {
            ConnectionClass con = new ConnectionClass();

            try
            {
                con.CreateConnection();
                con.OpenConnection();
                con._sqlCommand.CommandText = "SELECT * FROM users WHERE u_id = " + user_id;
                con._sqlCommand.CommandType = CommandType.Text;

                SqlDataReader sdr = con._sqlCommand.ExecuteReader();

                while (sdr.Read())
                {
                    lbl_user_name.Text = sdr["username"].ToString();
                    lbl_user_id.Text = sdr["u_id"].ToString();
                    profile_picture.Attributes.Add("src", sdr["profile_pic"].ToString());
                    lbl_full_name.Text = sdr["full_name"].ToString();
                    lbl_bio.Text = sdr["bio"].ToString();
                    DateTime joining = Convert.ToDateTime(sdr["joining_date"]);
                    lbl_joining_date.Text = "📅" + joining.ToString("dd MMM yyyy");
                    lbl_location.Text = "📍" + sdr["location"].ToString();
                    lbl_followers.Text = sdr["followers"].ToString() + " Follower(s)";
                    lbl_followings.Text = sdr["followings"].ToString() + " Following(s)";
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

        protected void btn_posts_Click(object sender, EventArgs e)
        {
            panel_posts.Visible = true;
            panel_shares.Visible = false;
            panel_reactions.Visible = false;
            panel_replies.Visible = false;
            panel_community.Visible = false;

            btn_posts.BorderStyle = BorderStyle.Solid;
            btn_posts.BorderWidth = 3;
            btn_posts.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_shares.BorderStyle = BorderStyle.None;
            btn_reactions.BorderStyle = BorderStyle.None;
            btn_replies.BorderStyle = BorderStyle.None;
            btn_community.BorderStyle = BorderStyle.None;

            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_posts(u_id);
        }

        protected void btn_shares_Click(object sender, EventArgs e)
        {
            panel_posts.Visible = false;
            panel_shares.Visible = true;
            panel_reactions.Visible = false;
            panel_replies.Visible = false;
            panel_community.Visible = false;

            btn_shares.BorderStyle = BorderStyle.Solid;
            btn_shares.BorderWidth = 3;
            btn_shares.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_posts.BorderStyle = BorderStyle.None;
            btn_reactions.BorderStyle = BorderStyle.None;
            btn_replies.BorderStyle = BorderStyle.None;
            btn_community.BorderStyle = BorderStyle.None;


            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_shares(u_id);
        }

        protected void btn_reactions_Click(object sender, EventArgs e)
        {
            panel_posts.Visible = false;
            panel_shares.Visible = false;
            panel_reactions.Visible = true;
            panel_replies.Visible = false;
            panel_community.Visible = false;

            btn_reactions.BorderStyle = BorderStyle.Solid;
            btn_reactions.BorderWidth = 3;
            btn_reactions.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_user_likes.BorderStyle = BorderStyle.Solid;
            btn_user_likes.BorderWidth = 3;
            btn_user_likes.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_posts.BorderStyle = BorderStyle.None;
            btn_shares.BorderStyle = BorderStyle.None;
            btn_replies.BorderStyle = BorderStyle.None;
            btn_community.BorderStyle = BorderStyle.None;

            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_likes(u_id);
        }

        protected void btn_replies_Click(object sender, EventArgs e)
        {
            panel_posts.Visible = false;
            panel_shares.Visible = false;
            panel_reactions.Visible = false;
            panel_replies.Visible = true;
            panel_community.Visible = false;

            btn_replies.BorderStyle = BorderStyle.Solid;
            btn_replies.BorderWidth = 3;
            btn_replies.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_posts.BorderStyle = BorderStyle.None;
            btn_reactions.BorderStyle = BorderStyle.None;
            btn_community.BorderStyle = BorderStyle.None;
            btn_shares.BorderStyle = BorderStyle.None;

            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_replies(u_id);
        }

        protected void btn_community_Click(object sender, EventArgs e)
        {
            panel_posts.Visible = false;
            panel_shares.Visible = false;
            panel_reactions.Visible = false;
            panel_replies.Visible = false;
            panel_community.Visible = true;

            btn_community.BorderStyle = BorderStyle.Solid;
            btn_community.BorderWidth = 3;
            btn_community.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_posts.BorderStyle = BorderStyle.None;
            btn_reactions.BorderStyle = BorderStyle.None;
            btn_replies.BorderStyle = BorderStyle.None;
            btn_shares.BorderStyle = BorderStyle.None;

            load_community();
        }

        void load_posts(long user_id)
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_posts";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@profile_user_id", user_id);
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                posts_repeater.DataSource = ds;
                posts_repeater.DataBind();
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

        void load_shares(long user_id)
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_shares";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@profile_user_id", user_id);
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                shares_repeater.DataSource = ds;
                shares_repeater.DataBind();
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

        void load_likes(long user_id)
        {
            btn_user_likes.BorderStyle = BorderStyle.Solid;
            btn_user_likes.BorderWidth = 3;
            btn_user_likes.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_user_dislikes.BorderStyle = BorderStyle.None;

            liked_posts_panel.Visible = true;
            disliked_posts_panel.Visible = false;

            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_liked_posts";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@profile_user_id", user_id);
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                liked_posts_repeater.DataSource = ds;
                liked_posts_repeater.DataBind();
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

        void load_dislikes(long user_id)
        {
            btn_user_dislikes.BorderStyle = BorderStyle.Solid;
            btn_user_dislikes.BorderWidth = 3;
            btn_user_dislikes.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_user_likes.BorderStyle = BorderStyle.None;

            liked_posts_panel.Visible = false;
            disliked_posts_panel.Visible = true;

            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_disliked_posts";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@profile_user_id", user_id);
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                disliked_posts_repeater.DataSource = ds;
                disliked_posts_repeater.DataBind();
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

        void load_replies(long user_id)
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "get_commented_posts";
                ob._sqlCommand.CommandType = CommandType.StoredProcedure;
                ob._sqlCommand.Parameters.AddWithValue("@profile_user_id", user_id);
                ob._sqlCommand.Parameters.AddWithValue("@current_user_id", Convert.ToInt32(Session["current_user"].ToString()));
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                replies_repeater.DataSource = ds;
                replies_repeater.DataBind();
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

        void load_community()
        {
            btn_followers_Click(null, null);
        }

        protected void btn_followers_Click(object sender, EventArgs e)
        {
            long user_id = Convert.ToInt64(Session["current_user"].ToString());
            panel_followers.Visible = true;
            panel_followings.Visible = false;
            panel_groups.Visible = false;

            btn_followers.BorderStyle = BorderStyle.Solid;
            btn_followers.BorderWidth = 3;
            btn_followers.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_followings.BorderStyle = BorderStyle.None;
            btn_groups.BorderStyle = BorderStyle.None;

            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "select username, u_id, profile_pic from users, follows where follower_id = u_id and following_id=" + user_id + " order by username";
                ob._sqlCommand.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                followers_repeater.DataSource = ds;
                followers_repeater.DataBind();
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

        protected void btn_followings_Click(object sender, EventArgs e)
        {
            long user_id = Convert.ToInt64(Session["current_user"].ToString());
            panel_followers.Visible = false;
            panel_followings.Visible = true;
            panel_groups.Visible = false;

            btn_followings.BorderStyle = BorderStyle.Solid;
            btn_followings.BorderWidth = 3;
            btn_followings.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_followers.BorderStyle = BorderStyle.None;
            btn_groups.BorderStyle = BorderStyle.None;

            ConnectionClass ob = new ConnectionClass();
            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "select username, u_id, profile_pic from users, follows where following_id = u_id and follower_id=" + user_id + " order by username";
                ob._sqlCommand.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                followings_repeater.DataSource = ds;
                followings_repeater.DataBind();
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

        protected void btn_groups_Click(object sender, EventArgs e)
        {
            panel_followers.Visible = false;
            panel_followings.Visible = false;
            panel_groups.Visible = true;

            btn_groups.BorderStyle = BorderStyle.Solid;
            btn_groups.BorderWidth = 3;
            btn_groups.BorderColor = System.Drawing.Color.FromArgb(102, 120, 186);

            btn_followers.BorderStyle = BorderStyle.None;
            btn_followings.BorderStyle = BorderStyle.None;
        }

        protected void posts_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
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

        protected void shares_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
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

        protected void btn_user_likes_Click(object sender, EventArgs e)
        {
            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_likes(u_id);
        }

        protected void btn_user_dislikes_Click(object sender, EventArgs e)
        {
            long u_id = Convert.ToInt64(Session["current_user"].ToString());
            load_dislikes(u_id);
        }

        protected void liked_posts_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
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

        protected void disliked_posts_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
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

        protected void btn_reply_Click(object sender, EventArgs e)
        {
            RepeaterItem item = (sender as Button).Parent as RepeaterItem;
            Label post_id = (Label)item.FindControl("lbl_p_id");

            long p_id = Convert.ToInt64(post_id.Text);

            Response.Redirect("Post.aspx?p_id=" + p_id);
        }

        protected void replies_repeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label label_like_text = (Label)e.Item.FindControl("lbl_like_text");
                Label label_p_id = (Label)e.Item.FindControl("lbl_p_id");
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


                Repeater comments_repeater = (Repeater)e.Item.FindControl("comments_repeater");
                long u_id = Convert.ToInt64(Session["current_user"].ToString());
                load_comments(comments_repeater, label_p_id.Text.ToString(), u_id);
            }
        }

        void load_comments(Repeater comments_repeater_, String p_id, long u_id)
        {
            ConnectionClass ob = new ConnectionClass();

            try
            {
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "select c_id, comment, users.u_id, username, profile_pic from comments, users where comments.p_id = " + p_id + " and comments.u_id = " + u_id + " and comments.u_id = users.u_id order by comment_time desc";
                ob._sqlCommand.CommandType = CommandType.Text;
                SqlDataAdapter sda = new SqlDataAdapter(ob._sqlCommand);
                DataSet ds = new DataSet();
                sda.Fill(ds);
                comments_repeater_.DataSource = ds;
                comments_repeater_.DataBind();
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

        protected void btn_del_post_Click(object sender, EventArgs e)
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                RepeaterItem item = (sender as Button).Parent as RepeaterItem;
                Label post_id = (Label)item.FindControl("lbl_p_id");
                long p_id = Convert.ToInt64(post_id.Text);               
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "DELETE FROM posts WHERE p_id = " + p_id;
                ob._sqlCommand.CommandType = CommandType.Text;
                int t = ob._sqlCommand.ExecuteNonQuery();
                if (t > 0)
                {
                    ShowAlertMessage("Post Deleted");
                    long u_id = Convert.ToInt64(Session["current_user"].ToString());
                    load_posts(u_id);
                }
                else
                    ShowAlertMessage("Error");
            }

            catch (Exception ex)
            {

            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }

        protected void btn_del_cmmnt_Click(object sender, EventArgs e)
        {
            ConnectionClass ob = new ConnectionClass();
            try
            {
                RepeaterItem item = (sender as Button).Parent as RepeaterItem;
                Label comment_id = (Label)item.FindControl("lbl_c_id");
                long c_id = Convert.ToInt64(comment_id.Text);
                ob.CreateConnection();
                ob.OpenConnection();
                ob._sqlCommand.CommandText = "DELETE FROM comments WHERE c_id = " + c_id;
                ob._sqlCommand.CommandType = CommandType.Text;
                int t = ob._sqlCommand.ExecuteNonQuery();
                if (t > 0)
                {
                    ShowAlertMessage("Comment Deleted");
                    long u_id = Convert.ToInt64(Session["current_user"].ToString());
                    load_replies(u_id);
                }
                else
                    ShowAlertMessage("Error");
            }

            catch (Exception ex)
            {

            }

            finally
            {
                ob.CloseConnection();
                ob.DisposeConnection();
            }
        }
    }
}