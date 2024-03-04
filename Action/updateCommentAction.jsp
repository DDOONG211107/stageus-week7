<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String userIdx = (String) session.getAttribute("userIdx");
String commentIdx = request.getParameter("commentIdx"); 
String postIdx = request.getParameter("postIdx");
String commentContentValue = request.getParameter("commentContent");
commentContentValue = commentContentValue.replace("\n", "\\n");
commentContentValue = commentContentValue.replace("\r", "\\r");

// 1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "UPDATE comment SET comment.content=? WHERE comment.idx = ?;";
PreparedStatement query = connect.prepareStatement(sql);
query.setString(1,commentContentValue);
query.setString(2,commentIdx);

// 3. sql 전송
query.executeUpdate();

response.sendRedirect("postAction.jsp?postIdx="+postIdx); 

%>


