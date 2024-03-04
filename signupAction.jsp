<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->

<%
request.setCharacterEncoding("utf-8"); 
String idValue = request.getParameter("id_value"); 
String pwValue = request.getParameter("pw_value"); 
String nameValue = request.getParameter("name_value");

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "INSERT INTO stageusaccount (id, pw, name) VALUES (?,?,?)";
PreparedStatement query = connect.prepareStatement(sql);
query.setString(1,idValue);
query.setString(2,pwValue);
query.setString(3,nameValue);

// 3. sql 전송
query.executeUpdate();

// jsp에서는 자동으로 db 커넥션은 끊어짐 (따로 close는 필요x)


%>
<script>
    alert("회원가입에 성공하였습니다")
    location.href="index.html"
    </script>


<%-- <head> </head>
<body>
  <h1>회원가입액션입니다</h1>
  <p><%=idValue%></p>
  <p><%=pwValue%></p>
  <p><%=nameValue%><p>
</body> --%>
