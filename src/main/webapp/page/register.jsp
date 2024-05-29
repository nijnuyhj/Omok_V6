<%--
  Created by IntelliJ IDEA.
  User: neu99
  Date: 2024-05-04
  Time: 오후 10:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <meta charset="UTF-8">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .box{
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            margin: 0;
            height: 45%;
            width: 20%;
            border: 1px black solid;
            padding: 20px;
        }
        .form-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10%;
            width: 100%;
        }
        input[type="submit"] {
            margin-top: 20%;
            margin-left: auto;
            margin-right: auto;
            display: block;
        }
    </style>
</head>
<body>
<div class="box">
    <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="form-item">
            ID <input type="text" name="id">
        </div>
        <div class="form-item">
            PW <input type="password" name="pw">
        </div>
        <div class="form-item">
            닉네임 <input type="text" name="nickname">
        </div>
        <input type="submit" value="가입하기">
    </form>
</div>
</body>
</html>
