<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="MicroLoom.Home.Notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: rgb(24, 24, 24);
        }

        .notif {
            background-color: #3D3D3D;
            margin: auto;
            width: 56%;
            border-radius: 8px;
            padding: 10px;
            overflow-wrap: break-word;
            font-size: 20px;
            color: white;
            margin-top: 8px;
            margin-bottom: 8px;
        }

        .notif:hover {
                background-color: #555555; 
                transform: scale(1.05); 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Repeater runat="server" ID="notifs_repeater">
        <ItemTemplate>
            <a href='<%#Eval("link") %>' style="text-decoration: none;">
                 <div class="notif">               
                <asp:Label ID="Label1" runat="server" Text='<%# Eval("notif_text") %>'></asp:Label>
                <br />
            </div>
            </a>        
        </ItemTemplate>
    </asp:Repeater>

</asp:Content>
