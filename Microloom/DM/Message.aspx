<%@ Page Title="" Language="C#" MasterPageFile="~/Home/Home.Master" AutoEventWireup="true" CodeBehind="Message.aspx.cs" Inherits="MicroLoom.DM.Message" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #3D3D3D;
        }

        /* Container styling */
        .messenger-container {
            display: flex;
            height: 100vh;
        }

        /* Friends list styling */
        .friends-list-container {
            width: 30%; /* 30% of the width for the friends list */
            background-color: #3D3D3D;
            overflow-y: auto;
            padding: 10px;
            border-right: 1px solid #ddd;
        }

        .search-box {
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .friends-list {
            list-style-type: none; /* Remove default bullets */
            margin: 0;
            padding: 0;
        }

        .friend {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #ddd;
        }

        .friend:hover {
                background-color: #e0e0e0;
        }

        /* Chat area styling */
        .chat-area {
            flex: 1; /* Take the remaining space */
            padding: 10px;
            background-color: #3D3D3D;
            display: flex;
            flex-direction: column;
        }

        /* Message styling */
        .message {
            padding: 10px;
            margin-bottom: 10px;
            background-color: #e7f3ff;
            border-radius: 8px;
            max-width: 60%;
        }

        .message-container {
            flex: 1;
            overflow-y: auto;
            padding-bottom: 20px;
        }

        .message-input {
            display: flex;
            padding: 10px;
            border-top: 1px solid #ddd;
        }

        #message {
            width: 90%;
        }

        #sendmessage {
            width: 8%;
            margin-left: 10px;
        }

        .message {
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 8px;
            max-width: 60%;
            word-wrap: break-word;
        }

        .message-left {
            background-color: #e7f3ff; /* Light blue background */
            color: black; /* Text color for the opposite user */
            text-align: left;
            align-self: flex-start;
            border-radius: 10px 10px 10px 0;
        }

        .message-right {
            background-color: #4CAF50; /* Green background */
            color: white; /* White text color for the current user */
            text-align: right;
            align-self: flex-end;
            border-radius: 10px 10px 0 10px;
        }

        /* To make the messages align properly */
        #chats {
            display: flex;
            flex-direction: column;
        }
    </style>

    <script src="../Scripts/jquery-3.4.1.min.js"></script>   
    <script src="../Scripts/jquery.signalR-2.2.2.min.js"></script>
    <script src="../signalr/hubs"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="messenger-container">
        
        <!-- Friends List Container -->
        <div class="friends-list-container">

            <!-- Search Box -->
            <asp:TextBox runat="server" class="search-box" ID="searchBox" placeholder="Search friends..." Width="78%"></asp:TextBox>
            <asp:Button ID="btn_clr" runat="server" Text="❌" Width="10%" Height="40px" OnClick="btn_clr_Click"/>
            <asp:Button ID="btn_search" runat="server" Text="🔍" Width="10%" Height="40px" OnClick="btn_search_Click"/>

            <!-- Chat List -->
            <asp:Repeater ID="friends_list" runat="server">
                <ItemTemplate>
                    <asp:Button ID="btn_followings" runat="server" Text='<%# Eval("username") %>' Width="100%" BorderStyle="None" Style="text-align: left; padding: 6px; margin-bottom: 6px; border-bottom: 2px solid white;" BackColor="#3D3D3D" ForeColor="White" OnClick="btn_followings_Click"/>
                </ItemTemplate>
            </asp:Repeater>

        </div>
        <!-- Chat Area -->
        <div class="chat-area" id="div_chat_area" runat="server" hidden="hidden">
            <asp:Label ID="lbl_chat_name" runat="server" Text="" ForeColor="White" Font-Size="30px"></asp:Label>
            <div class="message-input">
                <input type="text" id="message"/>
                <input type="button" id="sendmessage" value="Send" />
            </div>
            
            <!-- Chat Messages -->
            <div class="message-container" ID="messageContainer">   
               
                <asp:HiddenField ID="chat_group_name" runat="server" />
                <asp:HiddenField ID="current_username" runat="server" />

                <ul id="chats" style = "list-style-type: none; color: white; font-size: 25px;">
                    
                </ul>

            </div>

        </div>
    </div>

    <script type="text/javascript">
        $(function () {
            // Declare a proxy to reference the hub.
            var chat = $.connection.chatHub;

            // Create a function that the hub can call to broadcast messages.
            chat.client.broadcastMessage = function (name, message) {
                // Html encode display name and message.
                var encodedName = $('<div />').text(name).html();
                var encodedMsg = $('<div />').text(message).html();

                // Retrieve the current username from the hidden field.
                var currentUser = $('#<%= current_username.ClientID %>').val();

                // Determine if the message is from the current user
                var messageClass = (encodedName === currentUser) ? "message-right" : "message-left";

                // Create message HTML
                var messageHtml = '<li class="message ' + messageClass + '">' + encodedMsg + '</li>';

                // Append the message to the chat list
                $('#chats').append(messageHtml);

                // Auto-scroll to the latest message
                var chatContainer = $('#chats');
                chatContainer.scrollTop(chatContainer[0].scrollHeight);
            };

            // Retrieve the display name and chat group name from hidden fields.
            var displayName = $('#<%= current_username.ClientID %>').val();
            var chatGroupName = $('#<%= chat_group_name.ClientID %>').val();

            // Set initial focus to the message input box.
            $('#message').focus();

            // Start the connection.
            $.connection.hub.start().done(function () {
                chat.server.joinPrivateChat(chatGroupName).done(function () {
                    // Send message within the joined group
                    $('#sendmessage').click(function () {
                        var messageText = $('#message').val().trim();
                        if (messageText !== "") {
                            chat.server.sendPrivateMessage(chatGroupName, displayName, messageText);
                            $('#message').val('').focus();
                        }
                    });

                    // Allow sending messages with Enter key
                    $('#message').keypress(function (e) {
                        if (e.which === 13) { // Enter key
                            $('#sendmessage').click();
                        }
                    });
                });
            });
        });
    </script>

</asp:Content>
