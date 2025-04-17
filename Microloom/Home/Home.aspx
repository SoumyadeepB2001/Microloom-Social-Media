<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="MicroLoom.Home.Home1" %>

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
    <asp:Label ID="lbl_info" runat="server" ForeColor="White"></asp:Label>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
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
</asp:Content>
