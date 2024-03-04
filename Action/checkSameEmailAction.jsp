<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.io.*" %>


<%
request.setCharacterEncoding("utf-8"); 
String emailValue =request.getParameter("userEmailValue"); 

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM account WHERE email=?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,emailValue);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀

boolean isValid=false;
if(!result.next())
{
    // email이 유효한 상황
    isValid = true;
} 

%>

<script>
    const isValid = <%=isValid%>;
    if(isValid)
    {
        alert('email을 쓸 수 있습니다');
        window.history.back();
        
    }else {
        alert('email을 쓸 수 없습니다. ');
        window.history.back();

    }
</script>
