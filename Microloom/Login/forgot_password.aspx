<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="forgot_password.aspx.cs" Inherits="MicroLoom.Login.forgot_password" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>
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
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <asp:UpdatePanel ID="body_panel" runat="server">
                <ContentTemplate>
                    <asp:UpdatePanel ID="otp_panel" runat="server">
                        <ContentTemplate>
                            <section class="container">
                                <div class="login-container">
                                    <div class="circle circle-one"></div>
                                    <div class="form-container">
                                        <h2 class="opacity">FORGOT PASSWORD&nbsp<img src="/Logos/logo2.png" height="35" width="51" /></h2>
                                        <h3 class="opacity">Enter your username or email and we will send an OTP to the associated email address</h3>
                                        <div class="form">
                                            <asp:TextBox ID="txt_username_email" runat="server" placeholder="USERNAME OR EMAIL"></asp:TextBox>
                                            <asp:Button CssClass="btn_submit" ID="btn_send_otp" runat="server" Text="SEND OTP" BackColor="#0F3460" OnClick="btn_send_otp_Click"/>
                                        </div>
                                    </div>
                                    <div class="circle circle-two"></div>
                                </div>
                            </section>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <asp:UpdatePanel ID="update_password_panel" runat="server">
                        <ContentTemplate>
                            <section class="container">
                                <div class="login-container">
                                    <div class="circle circle-one"></div>
                                    <div class="form-container">
                                        <h2 class="opacity">CHANGE PASSWORD &nbsp<img src="/Logos/logo2.png" height="35" width="51" /></h2>
                                        <div class="form">
                                            <asp:TextBox ID="txt_otp" runat="server" placeholder="OTP" MaxLength="6" oninput="validateOTP(this)"></asp:TextBox>
                                            <span id="otpError" style="color: red;"></span>

                                            <asp:TextBox ID="txt_new_password" runat="server" placeholder="NEW PASSWORD" TextMode="Password"></asp:TextBox>
                                            <span id="passwordError" style="color: red;"></span>

                                            <asp:TextBox ID="txt_confirm_password" runat="server" placeholder="CONFIRM PASSWORD" TextMode="Password"></asp:TextBox>
                                            <span id="confirmPasswordError" style="color: red;"></span>
                                            <asp:Button CssClass="btn_submit" ID="btn_change_pass" runat="server" Text="CHANGE PASSWORD" BackColor="#0F3460" OnClick="btn_change_pass_Click" OnClientClick="return validateForm();" />
                                        </div>
                                    </div>
                                    <div class="circle circle-two"></div>
                                </div>
                            </section>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
    <script>
        function validateOTP(input) {
            input.value = input.value.replace(/\D/g, ''); // Remove non-numeric characters
            if (input.value.length > 6) {
                input.value = input.value.slice(0, 6); // Limit to 6 digits
            }
        }

        function validateForm() {
            let otp = document.getElementById('<%= txt_otp.ClientID %>').value.trim();
            let newPassword = document.getElementById('<%= txt_new_password.ClientID %>').value;
            let confirmPassword = document.getElementById('<%= txt_confirm_password.ClientID %>').value;

            let otpError = document.getElementById('otpError');
            let passwordError = document.getElementById('passwordError');
            let confirmPasswordError = document.getElementById('confirmPasswordError');

            // Reset error messages
            otpError.textContent = "";
            passwordError.textContent = "";
            confirmPasswordError.textContent = "";

            let isValid = true;

            // OTP Validation (6-digit number)
            if (!/^\d{6}$/.test(otp)) {
                otpError.textContent = "OTP must be a 6-digit number.";
                isValid = false;
            }

            // Password Validation (8-10 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char)
            let passwordPattern = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$/;
            if (!passwordPattern.test(newPassword)) {
                passwordError.textContent = "Password must contain 8-10 characters, at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.";
                isValid = false;
            }

            // Confirm Password Validation
            if (newPassword !== confirmPassword) {
                confirmPasswordError.textContent = "Passwords do not match.";
                isValid = false;
            }

            return isValid; // Prevents form submission if false
        }
    </script>
</body>
</html>
