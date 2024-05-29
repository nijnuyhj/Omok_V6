<%@page import="object.RankVO"%>
<%@page import="java.util.List"%>
<%@page import="query.RankDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>명예의 전당</title>
<link href="${pageContext.request.contextPath}/css/main-style.css" rel="stylesheet" type="text/css" />
</head>
<body style="display: inline-block;">
<% 
RankDAO dao = RankDAO.getInstance();
List<RankVO> winRateList = dao.listWinRate();
List<RankVO> winCountList = dao.listWinCount();
%>
<div class='header'>
	<input class="btn" type='button' onclick="location.href='<%=request.getContextPath()%>'" value="메인화면">
</div>
<div style="clear: right">
	<div class="colbox" style="display: inline-block;">
		<h2>👑 승률 👑</h2>
		<table style="width:370px">
			<tr>
				<th>순위</th>
				<th style="width:70%">
					닉네임<br>
					<span>ID</span>	
				</th>
				<th>승률(%)</th>
			</tr>
			<% if(winRateList.size() == 0){ %>
				<tr><td class="notResult" colspan="3">결과가 존재하지 않습니다.</td></tr>
			<% } else{
				for(RankVO vo: winRateList) {%>
					<tr>
						<td><%=vo.getRank()%></td>
						<td>
							<%=vo.getUserNickname()%><br>
							<span><%=vo.getUserId()%></span>	
						</td>
						<td><%=vo.getPoint()%>%</td>
					</tr>
			<%}}%>
		</table>
	</div>
	<div  class="colbox" style="display: inline-block;">
		<h2>👑 승리 횟수 👑</h2>
		<table style="width:370px">
			<tr>
				<th>순위</th>
				<th style="width:70%">
					닉네임<br>
					<span>ID</span>	
				</th>
				<th>승 수</th>
			</tr>
			<% if(winCountList.size() == 0){ %>
				<tr><td class="notResult" colspan="3">결과가 존재하지 않습니다.</td></tr>
			<% } else{
				for(RankVO vo: winCountList) {%>
					<tr>
						<td><%=vo.getRank()%></td>
						<td>
							<%=vo.getUserNickname()%><br>
							<span><%=vo.getUserId()%></span>	
						</td>
						<td><%=(int) vo.getPoint()%></td>
					</tr>
			<%}}%>
		</table>
	</div>
</div>
</body>
</html>