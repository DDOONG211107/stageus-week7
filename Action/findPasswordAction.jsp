<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->

<%
request.setCharacterEncoding("utf-8"); 
String emailValue = request.getParameter("userEmailValue"); 

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT password FROM account WHERE email = ?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,emailValue);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀
boolean isCorrect=false;
String userPassword="";

if(result.next())
{
    isCorrect = true;
    userPassword = "\""+ result.getString(1) + "\"";

} 

%>

<script>
    const isCorrect = <%=isCorrect%>;
    if(!isCorrect)
    {
        alert('잘못된 이메일주소입니다. 다시 시도해주세요.');
        window.location.href='../Page/findId.html';
    }
</script>

<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../global.css" />
    <title>비밀번호 찾기</title>
  </head>
  <body>
    <header id="isNotLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <a href="../Page/login.html" id="loginBtn">로그인</a>
        <a href="../Page/signup.html" id="signupBtn">회원가입</a>
    </header>
    
    <h1>비밀번호 찾기</h1>
    <h2>비밀번호는 <span id="userPassword"></span> 입니다.</h2>
    
    <script>
        if(<%=isCorrect%>)
        {
            document.getElementById("userPassword").innerText = <%=userPassword%>
        }
    </script>
  </body>
</html>


