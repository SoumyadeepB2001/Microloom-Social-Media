<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="NewPost.aspx.cs" Inherits="MicroLoom.Home.NewPost" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: rgb(24, 24, 24);
        }

        .background {
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
    </style>
    <script type="text/javascript">
        // Function to update the character count label
        function update() {
            var textbox = document.getElementById('<%= txt_post.ClientID %>');
            var label = document.getElementById('<%= lbl_char_count.ClientID %>');
            label.innerText = textbox.value.length + "/500";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="background">
        <asp:Label ID="lbl_username" runat="server" Text="" ForeColor="White" Font-Size="30px" Width="100%" Style="text-align: center;"></asp:Label>
    </div>

    <div class="background">
        <asp:TextBox ID="txt_post" runat="server" BorderStyle="Solid" BorderColor="Black" BorderWidth="2px" MaxLength="500" TextMode="MultiLine" Width="80%" Height="40px" Font-Size="20px" onInput="javascript:update()"></asp:TextBox>
        &nbsp &nbsp<asp:Button ID="btn_post" runat="server" Text="Post" BackColor="#212124" Width="15%" ForeColor="White" Height="40px" Font-Size="23px" OnClick="btn_post_Click" />
        <br />
        <asp:Label ID="lbl_char_count" runat="server" Text="0/500" Font-Size="20px" ForeColor="#666666"></asp:Label>
    </div>
</asp:Content>
