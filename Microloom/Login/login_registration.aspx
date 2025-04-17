<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login_registration.aspx.cs" Inherits="MicroLoom.Login.login_registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Log-in</title>
    <style>
        :root {
            --background: #1a1a2e;
            --color: #ffffff;
            --primary-color: #0f3460;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            box-sizing: border-box;
            font-family: "poppins";
            background: var(--background);
            color: var(--color);
            letter-spacing: 1px;
            transition: background 0.2s ease;
            -webkit-transition: background 0.2s ease;
            -moz-transition: background 0.2s ease;
            -ms-transition: background 0.2s ease;
            -o-transition: background 0.2s ease;
        }

        a {
            text-decoration: none;
            color: var(--color);
        }

        btn_css {
            text-decoration: none;
            background-color: transparent;
            border: none;
            cursor: help;
            padding: 0px;
        }

        h1 {
            font-size: 2.5rem;
        }

        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            position: relative;
            width: 22.2rem;
        }

        .form-container {
            border: 1px solid hsla(0, 0%, 65%, 0.158);
            box-shadow: 0 0 36px 1px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            backdrop-filter: blur(20px);
            z-index: 99;
            padding: 2rem;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            -ms-border-radius: 10px;
            -o-border-radius: 10px;
        }

        .login-container .form input {
            display: block;
            padding: 14.5px;
            width: 100%;
            margin: 2rem 0;
            color: var(--color);
            outline: none;
            background-color: #9191911f;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            letter-spacing: 0.8px;
            font-size: 15px;
            backdrop-filter: blur(15px);
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            -ms-border-radius: 5px;
            -o-border-radius: 5px;
        }

            .login-container .form input:focus {
                box-shadow: 0 0 16px 1px rgba(0, 0, 0, 0.2);
                animation: wobble 0.3s ease-in;
                -webkit-animation: wobble 0.3s ease-in;
            }

        .login-container .form button {
            background-color: var(--primary-color);
            color: var(--color);
            display: block;
            padding: 13px;
            border-radius: 5px;
            outline: none;
            font-size: 18px;
            letter-spacing: 1.5px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
            margin-bottom: 2rem;
            transition: all 0.1s ease-in-out;
            border: none;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            -ms-border-radius: 5px;
            -o-border-radius: 5px;
            -webkit-transition: all 0.1s ease-in-out;
            -moz-transition: all 0.1s ease-in-out;
            -ms-transition: all 0.1s ease-in-out;
            -o-transition: all 0.1s ease-in-out;
        }

            .login-container .form button:hover {
                box-shadow: 0 0 10px 1px rgba(0, 0, 0, 0.15);
                transform: scale(1.02);
                -webkit-transform: scale(1.02);
                -moz-transform: scale(1.02);
                -ms-transform: scale(1.02);
                -o-transform: scale(1.02);
            }

        .circle {
            width: 8rem;
            height: 8rem;
            background: var(--primary-color);
            border-radius: 50%;
            -webkit-border-radius: 50%;
            -moz-border-radius: 50%;
            -ms-border-radius: 50%;
            -o-border-radius: 50%;
            position: absolute;
        }

        .illustration {
            position: absolute;
            top: -14%;
            right: -2px;
            width: 90%;
        }

        .circle-one {
            top: 0;
            left: 0;
            z-index: -1;
            transform: translate(-45%, -45%);
            -webkit-transform: translate(-45%, -45%);
            -moz-transform: translate(-45%, -45%);
            -ms-transform: translate(-45%, -45%);
            -o-transform: translate(-45%, -45%);
        }

        .circle-two {
            bottom: 0;
            right: 0;
            z-index: -1;
            transform: translate(45%, 45%);
            -webkit-transform: translate(45%, 45%);
            -moz-transform: translate(45%, 45%);
            -ms-transform: translate(45%, 45%);
            -o-transform: translate(45%, 45%);
        }

        .register-forget {
            margin: 1rem 0;
            display: flex;
            justify-content: space-between;
        }

        .opacity {
            opacity: 0.6;
        }

        .theme-btn {
            cursor: pointer;
            transition: all 0.3s ease-in;
        }

            .theme-btn:hover {
                width: 40px !important;
            }

        @keyframes wobble {
            0% {
                transform: scale(1.025);
                -webkit-transform: scale(1.025);
                -moz-transform: scale(1.025);
                -ms-transform: scale(1.025);
                -o-transform: scale(1.025);
            }

            25% {
                transform: scale(1);
                -webkit-transform: scale(1);
                -moz-transform: scale(1);
                -ms-transform: scale(1);
                -o-transform: scale(1);
            }

            75% {
                transform: scale(1.025);
                -webkit-transform: scale(1.025);
                -moz-transform: scale(1.025);
                -ms-transform: scale(1.025);
                -o-transform: scale(1.025);
            }

            100% {
                transform: scale(1);
                -webkit-transform: scale(1);
                -moz-transform: scale(1);
                -ms-transform: scale(1);
                -o-transform: scale(1);
            }
        }

        .btn_submit {
            opacity: 0.6;
            background-color: var(--primary-color);
            color: var(--color);
            display: block;
            padding: 13px;
            border-radius: 5px;
            outline: none;
            font-size: 18px;
            letter-spacing: 1.5px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
            margin-bottom: 2rem;
            transition: all 0.1s ease-in-out;
            border: none;
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            -ms-border-radius: 5px;
            -o-border-radius: 5px;
            -webkit-transition: all 0.1s ease-in-out;
            -moz-transition: all 0.1s ease-in-out;
            -ms-transition: all 0.1s ease-in-out;
            -o-transition: all 0.1s ease-in-out;
        }

            .btn_submit:hover {
                box-shadow: 0 0 10px 1px rgba(0, 0, 0, 0.15);
                transform: scale(1.02);
                -webkit-transform: scale(1.02);
                -moz-transform: scale(1.02);
                -ms-transform: scale(1.02);
                -o-transform: scale(1.02);
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="body_panel" runat="server">
            <ContentTemplate>
                <asp:UpdatePanel ID="login_panel" runat="server">
                    <ContentTemplate>
                        <section class="container">
                            <div class="login-container">
                                <div class="circle circle-one"></div>
                                <div class="form-container">
                                    <h1 class="opacity">LOGIN &nbsp<img src="/Logos/logo2.png" height="35" width="51" /></h1>
                                    <div class="form">
                                        <asp:TextBox ID="login_username" runat="server" placeholder="USERNAME"></asp:TextBox>
                                        <asp:TextBox ID="login_password" runat="server" placeholder="PASSWORD" TextMode="Password"></asp:TextBox>
                                        <asp:Button CssClass="btn_submit" ID="btn_login" runat="server" Text="LOGIN" BackColor="#0F3460" OnClick="btn_login_Click" OnClientClick="return validateLogInForm();"/>
                                    </div>
                                    <div class="register-forget opacity">
                                        <asp:LinkButton ID="register" runat="server" OnClick="register_Click">Register</asp:LinkButton>
                                        <asp:LinkButton ID="forgot_pass" runat="server" OnClick="forgot_pass_Click">Forgot password?</asp:LinkButton>
                                    </div>
                                </div>
                                <div class="circle circle-two"></div>
                            </div>
                        </section>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <asp:UpdatePanel ID="register_panel" runat="server">
                    <ContentTemplate>
                        <section class="container">
                            <div class="login-container">
                                <div class="circle circle-one"></div>
                                <div class="form-container">
                                    <h1 class="opacity">REGISTER &nbsp<img src="/Logos/logo2.png" height="35" width="51" /></h1>
                                    <div class="form">
                                        <asp:TextBox ID="reg_username" runat="server" placeholder="USERNAME"></asp:TextBox>
                                        <asp:TextBox ID="reg_fullname" runat="server" placeholder="FULL NAME"></asp:TextBox>
                                        <asp:TextBox ID="reg_email" runat="server" placeholder="EMAIL"></asp:TextBox>
                                        <asp:TextBox ID="reg_password" runat="server" placeholder="PASSWORD" TextMode="Password"></asp:TextBox>
                                        <asp:Button CssClass="btn_submit" ID="btn_register" runat="server" Text="Send OTP" BackColor="#0F3460" OnClick="btn_register_Click" OnClientClick="return validateRegForm();"/>
                                    </div>
                                    <div class="register-forget opacity">
                                        Already an user?&nbsp<asp:LinkButton ID="log_in" runat="server" OnClick="log_in_Click">Log-in</asp:LinkButton>
                                    </div>
                                </div>
                                <div class="circle circle-two"></div>
                            </div>
                        </section>
                    </ContentTemplate>
                </asp:UpdatePanel>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="register" EventName="click" />
                <asp:AsyncPostBackTrigger ControlID="forgot_pass" EventName="click" />
                <asp:AsyncPostBackTrigger ControlID="log_in" EventName="click" />
            </Triggers>
        </asp:UpdatePanel>
    </form>

    <script>
        function validateRegForm() {
            let username = document.getElementById('<%= reg_username.ClientID %>').value.trim();
        let fullname = document.getElementById('<%= reg_fullname.ClientID %>').value.trim();
        let email = document.getElementById('<%= reg_email.ClientID %>').value.trim();
        let password = document.getElementById('<%= reg_password.ClientID %>').value;

        let usernamePattern = /^[A-Za-z][A-Za-z0-9_]*$/; // Username must start with a letter and contain only letters, numbers, or underscores
        let fullnamePattern = /^[A-Za-z\s]+$/; // Full name must only contain letters and spaces
        let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; // Email validation regex
        let passwordPattern = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$/; // 8-10 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char

        // Username length validation
        if (username.length < 3 || username.length > 15) {
            alert("Username must be between 3 and 15 characters long.");
            return false;
        }

        if (!usernamePattern.test(username)) {
            alert("Username must start with a letter and can only contain letters, numbers, and underscores.");
            return false;
        }

        if (!fullnamePattern.test(fullname)) {
            alert("Full Name must contain only letters and spaces.");
            return false;
        }

        if (!emailPattern.test(email)) {
            alert("Enter a valid email address.");
            return false;
        }

        // Password length validation
        if (password.length < 8 || password.length > 10) {
            alert("Password must be between 8 and 10 characters long.");
            return false;
        }

        if (!passwordPattern.test(password)) {
            alert("Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.");
            return false;
        }

        return true;
    }

    function validateLogInForm() {
        let username = document.getElementById('<%= login_username.ClientID %>').value.trim();
        let password = document.getElementById('<%= login_password.ClientID %>').value;

            // Check for empty username
            if (username === "") {
                alert("Please enter your username.");
                return false;
            }

            // Username length validation
            if (username.length < 3 || username.length > 15) {
                alert("Username must be between 3 and 15 characters long.");
                return false;
            }

            // Check for empty password
            if (password === "") {
                alert("Please enter your password.");
                return false;
            }

            // Password length validation
            if (password.length < 8 || password.length > 10) {
                alert("Password must be between 8 and 10 characters long.");
                return false;
            }

            return true;
        }
    </script>

</body>
</html>
