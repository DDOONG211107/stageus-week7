<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.io.*" %>

<%
request.setCharacterEncoding("utf-8"); 
String passwordValue =request.getParameter("userPasswordValue"); 
String userIdx =  (String) session.getAttribute("userIdx");

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM account WHERE idx=? AND password = ?;";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,userIdx);
query.setString(2,passwordValue);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀

boolean isValid=false;
if(result.next())
{
    // id가 유효한 상황. 탈퇴를 진행해야 함
    isValid = true;
    sql = "DELETE FROM account WHERE idx=? AND password = ?;";
    query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
    query.setString(1,userIdx);
    query.setString(2,passwordValue);
    query.executeUpdate(); // 여기까지 db에서 회원정보 삭제

    session.removeAttribute("userIdx");
    response.sendRedirect("../index.jsp");  
} 

%>

<script>

    const isValid = <%=isValid%>;   
    if(!isValid)
    {
        alert('잘못된 비밀번호입니다. 다시 시도해주세요.');
        window.history.back();
    }
    
</script>

