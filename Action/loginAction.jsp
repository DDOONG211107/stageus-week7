<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.*" %>


<%
request.setCharacterEncoding("utf-8"); 
String idValue = request.getParameter("userIdValue"); 
String pwValue = request.getParameter("userPasswordValue"); 

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM account WHERE id=? AND password=?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,idValue);
query.setString(2,pwValue);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀
boolean isCorrect=false;
if(result.next())
{
    isCorrect = true;
    String userIdx = result.getString(1);
    session.setAttribute("userIdx", userIdx);
    response.sendRedirect("../index.jsp"); 
} 

%>

<script>
    const isCorrectInput = <%=isCorrect%>;
    if(!isCorrectInput)
    {
        alert('잘못된 회원 정보입니다. 다시 시도해주세요.');
        window.location.href='../Page/login.html';
    }
</script>


