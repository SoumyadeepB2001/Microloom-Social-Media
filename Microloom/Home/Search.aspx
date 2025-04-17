<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="MicroLoom.Home.Search" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: rgb(24, 24, 24);
        }

        .back {
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lbl_search_message" runat="server" Text="" Width="100%" Font-Size="Medium" ForeColor="White"></asp:Label>
    <asp:Repeater ID="accounts_repeater" runat="server">
        <ItemTemplate>
            <div class="back">
                <a href='<%# string.Concat("/Home/ViewProfile.aspx?u_id=", Eval("u_id")) %>' style="text-decoration: none">
                    <asp:Image runat="server" src='<%# Eval("profile_pic") %>' height="55px" width="55px" style="border-radius: 50%; border: 3px solid; border-color: white;"/>
                    <asp:Label runat="server" Text='<%# Eval("username") %>' Font-Size="25px" ForeColor="White"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text='<%# Eval("full_name") %>' Font-Size="20px" ForeColor="White"></asp:Label>                    
                    <br />
                    <asp:Label runat="server" Text='<%# string.Concat(Eval("followers")," followers(s) | ", Eval("followings"), " following(s)") %>' Font-Size="20px" ForeColor="White"></asp:Label>
                    <br />
                    <asp:Label runat="server" Text='<%# Eval("bio") %>' Font-Size="20px" ForeColor="White"></asp:Label>
                </a>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
