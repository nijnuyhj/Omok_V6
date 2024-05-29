<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Main</title>
	<link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div>
		<div>
			<input class='btn_main' type='button' value='매칭하기'onclick="location.href='omok.jsp'"/>
			<input class='btn_main' type='button' value='명예의 전당' onclick="location.href='rank.jsp'"/>
		</div>
		<div>
			<input class='btn_main logout' type='button' value='로그아웃' onclick="location.href='logout'"/>
		</div>
	</div>	
</body>
</html>