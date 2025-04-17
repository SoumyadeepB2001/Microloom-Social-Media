<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="MicroLoom.Profile.EditProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
        body {
            background-color: rgb(24, 24, 24);
        }

        .box {
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

        .label {
            border-bottom: 0.5px solid;
            background-color: #3D3D3D;
            font-size: 20px;
            padding-bottom: 2px;
        }

        .center {
            display: flex;
            justify-content: center;
        }
    </style>
    <script type="text/javascript">
        // Function to update the character count label
        function update() {
            var textbox = document.getElementById('<%= txt_bio.ClientID %>');
            var label = document.getElementById('<%= lbl_char_count.ClientID %>');
            label.innerText = textbox.value.length + "/150";
        }

        function showBrowseDialog() {
            var fileuploadctrl = document.getElementById('<%=profile_pic_upload.ClientID%>');
            fileuploadctrl.click();
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="box">
        <div class="center">
            <asp:Image ID="img_profile_pic" runat="server" ImageAlign="Middle" Width="150" Height="150" />
        </div>
        <div class="center">
            <input type="button" onclick="showBrowseDialog()" value="🖊️" style="height: 50px; width: 50px; margin-top: 18px;" />
            <asp:Button ID="btn_del_profile_pic" runat="server" Text="🗑️" style="margin-left: 25px; margin-top: 18px;" OnClick="btn_del_profile_pic_Click"/>
        </div>        
    </div>

    <div class="box">
        <asp:Label ID="lbl_email" runat="server" Text="Email:"></asp:Label>
        <br />
        <asp:TextBox ID="txt_email" runat="server" Width="90%" Height="40px"></asp:TextBox>
        <br />
        <asp:Label ID="lbl_full_name" runat="server" Text="Full Name:"></asp:Label>
        <br />
        <asp:TextBox ID="txt_full_name" runat="server" Width="90%" Height="40px"></asp:TextBox>
        <br />
        <asp:Label ID="lbl_bio" runat="server" Text="Bio:"></asp:Label>
        <br />
        <asp:TextBox ID="txt_bio" runat="server" TextMode="MultiLine" Width="90%" Height="40px" Font-Size="20px" onInput="javascript:update()" MaxLength="150"></asp:TextBox>
        <br />
        <asp:Label ID="lbl_char_count" runat="server" Text="0/150" Font-Size="20px" ForeColor="#666666"></asp:Label>
        <br />
        <asp:Label ID="lbl_gender" runat="server" Text="Gender:"></asp:Label>
        <br />
        <asp:DropDownList ID="ddl_gender" runat="server" Width="50%" Height="40px">
            <asp:ListItem>Male</asp:ListItem>
            <asp:ListItem>Female</asp:ListItem>
            <asp:ListItem>Other</asp:ListItem>
        </asp:DropDownList>
        <br />
        <asp:Label ID="lbl_location" runat="server" Text="Location:"></asp:Label>
        <asp:TextBox ID="txt_location" runat="server" Width="90%" Height="40px"></asp:TextBox>
        <br />
        <br />
        <div class="center">
            <asp:Button ID="btn_update" runat="server" Text="Update" OnClick="btn_update_Click"/>&nbsp &nbsp &nbsp<asp:Button ID="btn_cancel" runat="server" Text="Cancel" OnClick="btn_cancel_Click"/>
        </div>
    </div>

     <div class="box">
        <asp:Label ID="lbl_change_pass" runat="server" Text="Change your password"></asp:Label>
        <br />
        <asp:Label ID="lbl_current_pass" runat="server" Text="Enter your current password:"></asp:Label>
        <br />
        <asp:TextBox ID="txt_current_pass" runat="server" TextMode="Password"></asp:TextBox>
        <br />
        <asp:Label ID="lbl_new_pass" runat="server" Text="Enter your new password:"></asp:Label>
        <br />
        <asp:TextBox ID="txt_new_pass" runat="server" TextMode="Password"></asp:TextBox>
        <br /> <br />
        <asp:Button ID="btn_change_pass" runat="server" Text="Change password" BackColor="Red" ForeColor="White" OnClick="btn_change_pass_Click"/>
    </div>

    <div class="box" style="text-align: center;">
        <asp:Button ID="btn_delete_account" runat="server" Text="Delete your account" BackColor="Red" ForeColor="White" OnClick="btn_delete_account_Click"/>
        <asp:Label ID="lbl_confirm" runat="server" Text="Do you really want to delete your account?" Visible="False"></asp:Label>
        <asp:Button ID="btn_yes" runat="server" Text="Yes" Visible="False" BackColor="Red" ForeColor="White" OnClick="btn_yes_Click"/>&nbsp&nbsp<asp:Button ID="btn_no" runat="server" Text="No" Visible="False" BackColor="Green" ForeColor="White" OnClick="btn_no_Click"/>
    </div>


    <%--File upload control--%> 
    <asp:FileUpload ID="profile_pic_upload" runat="server" Width="0" Height="0" onchange="handleFileChange()"/>
    <asp:Label ID="lbl_user_id" runat="server" Text="Label" Visible="false" Width="0" Height="0"></asp:Label>
    <asp:Label ID="lbl_old_profile_pic" runat="server" Text="" Visible="false"></asp:Label>
    <asp:Button ID="btn_upload" runat="server" Text="Upload" style="visibility:hidden" Height="0" Width="0" OnClick="btn_upload_Click"/>
</asp:Content>
