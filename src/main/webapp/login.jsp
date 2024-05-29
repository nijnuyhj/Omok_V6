<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet" type="text/css" />
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
	td, input {
		font-size: 20px;
	}
</style>
<script type="text/javascript">
window.onload = getCookieValue();

function getCookieValue(){
	if(document.cookie.startsWith("loginCookie=")){
    	console.log(document.cookie);
        return location.href="${pageContext.request.contextPath}/autoLogin";
    }
}

function fnLogin(){
	
	var data = {
			id: $('#id').val(),
			pwd: $('#pwd').val(),
	}
    if(data.id.length == 0 || data.id == ""){
        $('#fail').html("아이디를 입력해 주세요.")
    }else if(data.pwd.length = 0 || data.pwd == ""){
        $('#fail').html("비밀번호를 입력해 주세요.")
    }else{
    	console.log(data);
    	$.ajax({
            // 로그인 수행 요청
            type: "POST", // method type
            url: "login", // 요청할 url
            data: data, // 전송할 데이터
            dataType: "text", // 응답 받을 데이터 type
            success : function(resp, textStatus){
            	console.log(resp)
            	if(resp == "false"){
                    $('#fail').html("아이디 비밀번호를 확인해 주세요.")
            	}else{

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


function fnJoin(){
    frmLogin.method="get";
    frmLogin.action="register" //회원가입 주소 넣기
    frmLogin.submit();
}
</script>
</head>
<body>
	<div>
	<div class="colbox">
	<h1>로그인</h1>	
	<form name="frmLogin">
	<table>
		<tr>
			<td>ID</td>
			<td><input type='text' id= "id"></td>
		</tr>
		<tr>
			<td>PW</td>
			<td><input type= "password" id= "pwd" ></td>
		</tr>
		<tr>
			<td colspan="2" id="fail">
			</td>
		</tr>
		<tr style="height:100px">
			<td colspan="2">
        		<input type= "button" value= "회원가입" onclick="fnJoin()" class="btn"> 
				<input type= "button" value= "로그인" onclick="fnLogin()" class="btn">
			</td>
		</tr>
        </table>
	</form>
	</div>
	</div>
</body>
</html>