<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->

<%
request.setCharacterEncoding("utf-8"); 
String idValue = request.getParameter("userIdValue"); 
String emailValue = request.getParameter("userEmailValue");
String nicknameValue = request.getParameter("userNicknameValue");
String passwordValue = request.getParameter("userPasswordValue");
String passwordCheckValue = request.getParameter("userPasswordCheckValue");
// 여기서 세션에서 userIdx를 받아와서 예외처리를 해줘야 함 
boolean passwordIsSame = false;

if(passwordValue.equals(passwordCheckValue))
{
    passwordIsSame = true;
    //1. db통신
    Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

    //2. sql 작성
    String sql = "INSERT INTO account (id, email, nickname, password) VALUES (?,?,?,?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1,idValue);
    query.setString(2,emailValue);
    query.setString(3,nicknameValue);
    query.setString(4,passwordValue);

    // 3. sql 전송
    query.executeUpdate();
} 

%>

<script>

    const passwordIsSame = <%=passwordIsSame%>;
    if(passwordIsSame) {
        alert("회원가입에 성공햇음!!!");
        location.href="../Page/login.html";
    }else {
        alert("비밀번호가 일치하지 않습니다");
        window.history.back();
    }
</script>
