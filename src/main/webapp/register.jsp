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
    <title>Resister</title>
    <meta charset="UTF-8">
    <link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet" type="text/css" />
	<style>
		td, input {
			font-size: 20px;
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script>
	function fnRegister(){
		
		var data = {
				id: $('#id').val(),
				pw: $('#pw').val(),
				nickname: $('#nickname').val(),
		}
		console.log(data);
	    if(data.id.length == 0 || data.id == ""){
	        $('#fail').html("아이디를 입력해주세요.");
	    }else if(data.pw.length = 0 || data.pw == ""){
	        $('#fail').html("비밀번호를 입력해주세요.");
	    }else if(data.nickname.length = 0 || data.nickname == ""){
	        $('#fail').html("닉네임을 입력해주세요.");
	    }else{
	    	$.ajax({
	            // 로그인 수행 요청
	            type: "POST", // method type
	            url: "register", // 요청할 url
	            data: data, // 전송할 데이터
	            dataType: "text", // 응답 받을 데이터 type
	            success : function(resp, textStatus){
	            	if(resp == "false"){
	                    $('#fail').html("다른 아이디를 입력해주세요.");
	            	}else{
	            		alert("회원가입 성공, 로그인 페이지로 이동")
	            		location.href = "index.jsp";
	            	}
	            },
	            error:function (data, textStatus) {
	                $('#fail').html("관리자에게 문의하세요.") // 서버오류
	                console.log('error', data, textStatus);
	            }
	    	})
		}
	}
	</script>
</head>
<body>
<div><div class="colbox">
	<h1>회원 가입</h1>
    <form method="post" action="${pageContext.request.contextPath}/register">
    <table>
		<tr>
			<td>ID</td>
			<td><input type='text' id= "id"></td>
		</tr>
		<tr>
			<td>PW</td>
			<td><input type= "password" id= "pw" ></td>
		</tr>
		<tr>
			<td>닉네임</td>
			<td><input type= "text" id= "nickname" ></td>
		</tr>
		<tr>
			<td colspan="2" id="fail">
			</td>
		</tr>
        <tr>
        	<td colspan="2"><input type=button value="가입하기" onclick="fnRegister()" class="btn"></td>
        </tr>
    </table>
    </form>
    
</div></div>
</body>
</html>
