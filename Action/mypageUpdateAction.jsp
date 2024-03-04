<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.io.*" %>


<%
request.setCharacterEncoding("utf-8"); 

String idValue = request.getParameter("userIdValue"); 
String emailValue = request.getParameter("userEmailValue");
String nicknameValue = request.getParameter("userNicknameValue");
String passwordValue = request.getParameter("userPasswordValue");
String userIdx =  (String) session.getAttribute("userIdx");


//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "UPDATE account SET id=?, email=?, nickname=?, password=? WHERE idx = ?";
PreparedStatement query = connect.prepareStatement(sql);
query.setString(1,idValue);
query.setString(2,emailValue);
query.setString(3,nicknameValue);
query.setString(4,passwordValue);
query.setString(5, userIdx);

// 3. sql 전송
query.executeUpdate();

response.sendRedirect("mypageAction.jsp"); 

%>
