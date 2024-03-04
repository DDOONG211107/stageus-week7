<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.io.*" %>


<%
request.setCharacterEncoding("utf-8"); 
String titleValue = request.getParameter("titleValue"); 
String contentValue = request.getParameter("contentValue");
contentValue = contentValue.replace("\n", "\\n");
contentValue = contentValue.replace("\r", "\\r");
String postIdx = request.getParameter("postIdx");

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "UPDATE post SET post.title=?, post.content=? WHERE post.idx = ?"; // 여기에 account.idx (세션에서 가져오기) 까지 where안에 포함하면 한번 더 예외처리 가능 (매우 중요한 예외처리)
PreparedStatement query = connect.prepareStatement(sql);
query.setString(1,titleValue);
query.setString(2,contentValue);
query.setString(3,postIdx);

// 3. sql 전송
query.executeUpdate();

response.sendRedirect("postAction.jsp?postIdx="+postIdx); 

%>