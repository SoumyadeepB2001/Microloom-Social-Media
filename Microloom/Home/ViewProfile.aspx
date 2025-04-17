<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="ViewProfile.aspx.cs" Inherits="MicroLoom.Home.ViewProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        body {
            background-color: rgb(24, 24, 24);
        }

        .profile {
            background-color: #3D3D3D;
            margin: auto;
            border-radius: 8px;
            width: 56%;
            padding: 10px;
            overflow-wrap: break-word;
            font-size: 29px;
            color: white;
            margin-top: 8px;
            margin-bottom: 8px;
        }

        .posts_shares {
            margin: auto;
            width: 100%;
            overflow-wrap: break-word;
            font-size: 25px;
            display: flex;
            align-items: center;
            justify-content: space-around;
        }

        .post {
            background-color: #3D3D3D;
            margin: auto;
            width: 56%;
            border-radius: 8px;
            padding: 10px;
            overflow-wrap: break-word;
            font-size: 29px;
            color: white;
            margin-top: 8px;
            margin-bottom: 8px;
        }

        .user_name {
            border-bottom: 0.5px solid;
            background-color: #3D3D3D;
            font-size: 20px;
            padding-bottom: 2px;
        }

        .like_reply_share {
            display: flex;
            align-items: center;
            justify-content: space-around;
            font-size: 17px;
        }

        .comment_user_name {
            border-bottom: 0.5px solid;
            background-color: rgb(24, 24, 24);
            font-size: 14px;
            padding-bottom: 2px;
        }

        .comment {
            background-color: rgb(24, 24, 24);
            margin: auto;
            width: 56%;
            padding: 10px;
            overflow-wrap: break-word;
            font-size: 15px;
            color: white;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="profile">
                <asp:Image ID="profile_picture" runat="server" src="#" Height="100" Width="100" Style="border-radius: 50%; border: 3px solid;" />
                <asp:Label ID="lbl_user_name" runat="server"></asp:Label>&nbsp<asp:Label ID="lbl_user_id" runat="server" Font-Size="20px" Visible="False"></asp:Label>
                <asp:Button ID="btn_follow" runat="server" Text="Follow +" Height="50" Width="135" BackColor="#212124" ForeColor="White" OnClick="btn_follow_Click"/>
                <br />
                <asp:Label ID="lbl_full_name" runat="server" Font-Size="20px"></asp:Label>
                <br />
                <asp:Label ID="lbl_bio" runat="server" Font-Size="20px"></asp:Label>
                <br />
                <asp:Label ID="lbl_joining_date" runat="server" Font-Size="20px"></asp:Label>&nbsp<asp:Label ID="lbl_location" runat="server" Font-Size="20px"></asp:Label>
                <br />
                <asp:Label ID="lbl_followers" runat="server" Font-Size="20px"></asp:Label>
                <asp:Label ID="lbl_followings" runat="server" Font-Size="20px"></asp:Label>

                <div class="posts_shares">
                    <asp:Button ID="btn_posts" OnClick="btn_posts_Click" runat="server" Text="Posts" BackColor="#212124" Width="20%" ForeColor="White" BorderStyle="Solid" BorderColor="#8587ed" BorderWidth="3px" />
                    <asp:Button ID="btn_shares" OnClick="btn_shares_Click" runat="server" Text="Shares" BackColor="#212124" Width="20%" ForeColor="White" BorderStyle="None" />
                    <asp:Button ID="btn_reactions" OnClick="btn_reactions_Click" runat="server" Text="Reactions" BackColor="#212124" Width="20%" ForeColor="White" BorderStyle="None" />
                    <asp:Button ID="btn_replies" runat="server" OnClick="btn_replies_Click" Text="Replies" BackColor="#212124" Width="20%" ForeColor="White" BorderStyle="None" />
                    <asp:Button ID="btn_community" runat="server" OnClick="btn_community_Click" Text="Community" BackColor="#212124" Width="20%" ForeColor="White" BorderStyle="None" />
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btn_posts" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_shares" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_reactions" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_community" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_replies" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="update_panel" runat="server">

        <ContentTemplate>

            <asp:UpdatePanel ID="panel_posts" runat="server">

                <ContentTemplate>

                    <asp:Repeater runat="server" ID="posts_repeater" OnItemDataBound="posts_repeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="post">
                                <div class="user_name">
                                    <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                        <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                    </a>
                                </div>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("post") %>'></asp:Label>
                                <br />

                                <div class="post_info">
                                    <asp:Label ID="lbl_no_likes" runat="server" Text='<%# string.Concat(Eval("likes")," likes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_dislikes" runat="server" Text='<%# string.Concat(Eval("dislikes")," dislikes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_replies" runat="server" Text='<%# string.Concat(Eval("comments")," replies | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_shares" runat="server" Text='<%# string.Concat(Eval("shares")," shares | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_post_time" runat="server" Text='<%# string.Concat(Eval("post_time", "{0:dd MMM yyyy}"), " at ", Eval("post_time", "{0:hh:mm tt}")) %>' Font-Size="12"></asp:Label>
                                </div>
                                <asp:Label ID="lbl_like_text" runat="server" Text='<%# Eval("LikeText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_share_text" runat="server" Text='<%# Eval("ShareText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_p_id" runat="server" Text='<%# Eval("p_id") %>' Visible="False"></asp:Label>
                                <div class="like_reply_share">
                                    <asp:Button ID="btn_like" runat="server" Text="Like 👍" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_like_Click" />
                                    <asp:Button ID="btn_dislike" runat="server" Text="Dislike 👎" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_dislike_Click" />
                                    <asp:Button ID="btn_reply" runat="server" Text="Reply 💬" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_reply_Click" />
                                    <asp:Button ID="btn_share" runat="server" Text="Share ↩️" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_share_Click" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </ContentTemplate>

            </asp:UpdatePanel>

            <asp:UpdatePanel ID="panel_shares" runat="server" Visible="false">
                <ContentTemplate>
                    <asp:Repeater runat="server" ID="shares_repeater" OnItemDataBound="shares_repeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="post">
                                <div class="user_name">
                                    <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                        <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                    </a>
                                </div>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("post") %>'></asp:Label>
                                <br />

                                <div class="post_info">
                                    <asp:Label ID="lbl_no_likes" runat="server" Text='<%# string.Concat(Eval("likes")," likes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_dislikes" runat="server" Text='<%# string.Concat(Eval("dislikes")," dislikes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_replies" runat="server" Text='<%# string.Concat(Eval("comments")," replies | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_shares" runat="server" Text='<%# string.Concat(Eval("shares")," shares | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_post_time" runat="server" Text='<%# string.Concat(Eval("post_time", "{0:dd MMM yyyy}"), " at ", Eval("post_time", "{0:hh:mm tt}")) %>' Font-Size="12"></asp:Label>
                                </div>
                                <asp:Label ID="lbl_like_text" runat="server" Text='<%# Eval("LikeText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_share_text" runat="server" Text='<%# Eval("ShareText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_p_id" runat="server" Text='<%# Eval("p_id") %>' Visible="False"></asp:Label>
                                <div class="like_reply_share">
                                    <asp:Button ID="btn_like" runat="server" Text="Like 👍" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_like_Click" />
                                    <asp:Button ID="btn_dislike" runat="server" Text="Dislike 👎" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_dislike_Click" />
                                    <asp:Button ID="btn_reply" runat="server" Text="Reply 💬" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_reply_Click" />
                                    <asp:Button ID="btn_share" runat="server" Text="Share ↩️" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_share_Click" />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:UpdatePanel ID="panel_reactions" runat="server" Visible="false">
                <ContentTemplate>
                    <div class="post">
                        <div class="posts_shares">
                            <asp:Button ID="btn_user_likes" runat="server" Text="Liked Posts" BackColor="#212124" Width="50%" ForeColor="White" BorderStyle="None" OnClick="btn_user_likes_Click" />
                            <asp:Button ID="btn_user_dislikes" runat="server" Text="Disliked Posts" BackColor="#212124" Width="50%" ForeColor="White" BorderStyle="None" OnClick="btn_user_dislikes_Click" />
                        </div>
                    </div>

                    <asp:UpdatePanel ID="liked_posts_panel" runat="server">
                        <ContentTemplate>
                            <asp:Repeater runat="server" ID="liked_posts_repeater" OnItemDataBound="liked_posts_repeater_ItemDataBound">
                                <ItemTemplate>
                                    <div class="post">
                                        <div class="user_name">
                                            <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                                <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                            </a>
                                        </div>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("post") %>'></asp:Label>
                                        <br />

                                        <div class="post_info">
                                            <asp:Label ID="lbl_no_likes" runat="server" Text='<%# string.Concat(Eval("likes")," likes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_dislikes" runat="server" Text='<%# string.Concat(Eval("dislikes")," dislikes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_replies" runat="server" Text='<%# string.Concat(Eval("comments")," replies | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_shares" runat="server" Text='<%# string.Concat(Eval("shares")," shares | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_post_time" runat="server" Text='<%# string.Concat(Eval("post_time", "{0:dd MMM yyyy}"), " at ", Eval("post_time", "{0:hh:mm tt}")) %>' Font-Size="12"></asp:Label>
                                        </div>
                                        <asp:Label ID="lbl_like_text" runat="server" Text='<%# Eval("LikeText") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lbl_share_text" runat="server" Text='<%# Eval("ShareText") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lbl_p_id" runat="server" Text='<%# Eval("p_id") %>' Visible="False"></asp:Label>
                                        <div class="like_reply_share">
                                            <asp:Button ID="btn_like" runat="server" Text="Like 👍" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_like_Click" />
                                            <asp:Button ID="btn_dislike" runat="server" Text="Dislike 👎" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_dislike_Click" />
                                            <asp:Button ID="btn_reply" runat="server" Text="Reply 💬" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_reply_Click" />
                                            <asp:Button ID="btn_share" runat="server" Text="Share ↩️" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_share_Click" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <asp:UpdatePanel ID="disliked_posts_panel" runat="server">
                        <ContentTemplate>
                            <asp:Repeater runat="server" ID="disliked_posts_repeater" OnItemDataBound="disliked_posts_repeater_ItemDataBound">
                                <ItemTemplate>
                                    <div class="post">
                                        <div class="user_name">
                                            <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                                <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                            </a>
                                        </div>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("post") %>'></asp:Label>
                                        <br />

                                        <div class="post_info">
                                            <asp:Label ID="lbl_no_likes" runat="server" Text='<%# string.Concat(Eval("likes")," likes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_dislikes" runat="server" Text='<%# string.Concat(Eval("dislikes")," dislikes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_replies" runat="server" Text='<%# string.Concat(Eval("comments")," replies | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_shares" runat="server" Text='<%# string.Concat(Eval("shares")," shares | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_post_time" runat="server" Text='<%# string.Concat(Eval("post_time", "{0:dd MMM yyyy}"), " at ", Eval("post_time", "{0:hh:mm tt}")) %>' Font-Size="12"></asp:Label>
                                        </div>
                                        <asp:Label ID="lbl_like_text" runat="server" Text='<%# Eval("LikeText") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lbl_share_text" runat="server" Text='<%# Eval("ShareText") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lbl_p_id" runat="server" Text='<%# Eval("p_id") %>' Visible="False"></asp:Label>
                                        <div class="like_reply_share">
                                            <asp:Button ID="btn_like" runat="server" Text="Like 👍" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_like_Click" />
                                            <asp:Button ID="btn_dislike" runat="server" Text="Dislike 👎" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_dislike_Click" />
                                            <asp:Button ID="btn_reply" runat="server" Text="Reply 💬" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_reply_Click" />
                                            <asp:Button ID="btn_share" runat="server" Text="Share ↩️" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_share_Click" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:UpdatePanel ID="panel_replies" runat="server" Visible="false">
                <ContentTemplate>
                    <asp:Repeater runat="server" ID="replies_repeater" OnItemDataBound="replies_repeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="post">
                                <div class="user_name">
                                    <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                        <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                    </a>
                                </div>
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("post") %>'></asp:Label>
                                <br />

                                <div class="post_info">
                                    <asp:Label ID="lbl_no_likes" runat="server" Text='<%# string.Concat(Eval("likes")," likes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_dislikes" runat="server" Text='<%# string.Concat(Eval("dislikes")," dislikes | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_replies" runat="server" Text='<%# string.Concat(Eval("comments")," replies | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_no_shares" runat="server" Text='<%# string.Concat(Eval("shares")," shares | ") %>' Font-Size="12"></asp:Label><asp:Label ID="lbl_post_time" runat="server" Text='<%# string.Concat(Eval("post_time", "{0:dd MMM yyyy}"), " at ", Eval("post_time", "{0:hh:mm tt}")) %>' Font-Size="12"></asp:Label>
                                </div>
                                <asp:Label ID="lbl_like_text" runat="server" Text='<%# Eval("LikeText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_share_text" runat="server" Text='<%# Eval("ShareText") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lbl_p_id" runat="server" Text='<%# Eval("p_id") %>' Visible="False"></asp:Label>
                                <div class="like_reply_share">
                                    <asp:Button ID="btn_like" runat="server" Text="Like 👍" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_like_Click" />
                                    <asp:Button ID="btn_dislike" runat="server" Text="Dislike 👎" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_dislike_Click" />
                                    <asp:Button ID="btn_reply" runat="server" Text="Reply 💬" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_reply_Click" />
                                    <asp:Button ID="btn_share" runat="server" Text="Share ↩️" BackColor="#212124" Width="25%" ForeColor="White" OnClick="btn_share_Click" />
                                </div>
                            </div>

                            <asp:Repeater ID="comments_repeater" runat="server">
                                <ItemTemplate>

                                    <div class="comment">
                                        <div class="comment_user_name">
                                            <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                                <img src='<%# Eval("profile_pic") %>' height="25" width="25" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="lbl_post_username" runat="server" Text='<%# Eval("username") %>' ForeColor="White"></asp:Label>
                                            </a>
                                        </div>
                                        <asp:Label ID="lbl_comment" runat="server" Text='<%# Eval("comment") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                        </ItemTemplate>
                    </asp:Repeater>
                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:UpdatePanel ID="panel_community" runat="server" Visible="false">
                <ContentTemplate>

                    <div class="post">
                        <div class="posts_shares">
                            <asp:Button ID="btn_followers" runat="server" Text="Followers" BackColor="#212124" Width="33.333%" ForeColor="White" BorderStyle="None" OnClick="btn_followers_Click" />
                            <asp:Button ID="btn_followings" runat="server" Text="Following" BackColor="#212124" Width="33.333%" ForeColor="White" BorderStyle="None" OnClick="btn_followings_Click" />
                            <asp:Button ID="btn_groups" runat="server" Text="Groups" BackColor="#212124" Width="33.333%" ForeColor="White" BorderStyle="None" OnClick="btn_groups_Click" />
                        </div>

                        <asp:UpdatePanel ID="panel_followers" runat="server">
                            <ContentTemplate>
                                <asp:Repeater ID="followers_repeater" runat="server">
                                    <ItemTemplate>
                                        <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                            <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="Label1" runat="server" ForeColor="White" Text='<%# Eval("username") %>' Font-Size="18px"></asp:Label>
                                        </a>
                                        <br />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <asp:UpdatePanel ID="panel_followings" runat="server">
                            <ContentTemplate>
                                <asp:Repeater ID="followings_repeater" runat="server">
                                    <ItemTemplate>
                                        <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                                            <img src='<%# Eval("profile_pic") %>' height="35" width="35" style="border-radius: 50%; border: 3px solid; border-color: white;" />&nbsp<asp:Label ID="Label1" runat="server" ForeColor="White" Text='<%# Eval("username") %>' Font-Size="18px"></asp:Label>
                                        </a>
                                        <br />
                                    </ItemTemplate>
                                </asp:Repeater>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <asp:UpdatePanel ID="panel_groups" runat="server">
                            <ContentTemplate>
                                <p>List of Groups</p>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>

        </ContentTemplate>

        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btn_posts" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_shares" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_reactions" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_community" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_replies" EventName="Click" />
        </Triggers>

    </asp:UpdatePanel>

</asp:Content>
