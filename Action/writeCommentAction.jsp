<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.*" %>
<%@ page session="true" %>

<%
request.setCharacterEncoding("utf-8"); 
String postIdxValue = request.getParameter("postIdx"); 
String contentValue = request.getParameter("commentContentValue"); 
contentValue = contentValue.replace("\n", "\\n");
contentValue = contentValue.replace("\r", "\\r");
String userIdx = (String) session.getAttribute("userIdx");

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "INSERT INTO comment ( writer_idx, post_idx, content ) VALUES (?, ?, ?)";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,userIdx);
query.setString(2,postIdxValue);
query.setString(3,contentValue);

// 3. sql 전송
query.executeUpdate(); // select가 아닐때는 excuteUpdate()

response.sendRedirect("postAction.jsp?postIdx="+postIdxValue);

%>


