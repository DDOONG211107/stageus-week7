<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String userIdx = (String) session.getAttribute("userIdx");

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM post WHERE post.writer_idx = ? ORDER BY post.time DESC;";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,userIdx);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀

result.next();
String postIdx = result.getString(1); // 1번 row의 id값을 가져옴
String postRedirect = "postAction.jsp?postIdx="+postIdx;
response.sendRedirect(postRedirect);

%>

