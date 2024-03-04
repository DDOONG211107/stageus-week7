<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String userIdx = (String) session.getAttribute("userIdx");
String postIdx = request.getParameter("postIdx"); 
String postId = "\""+postIdx+"\"";

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT post.title, post.content FROM post WHERE idx = ?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,postIdx);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀
result.next(); // 꼭 한번 next()를 해야 함

//4. 데이터 정제 (프론트엔드에서 사용하기 쉽게 여기에서 2차원 리스트로 편집해서 전달)
ArrayList<String> postDetail = new ArrayList<String>(); // jsp에서 리스트 만드는 방법

String title = "\""+ result.getString(1) +"\""; 
String content ="\""+ result.getString(2)+"\""; 

postDetail.add(title);
postDetail.add(content);

%>

<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../global.css" />
    <title>글 수정하기</title>
  </head>

  <body>

    <header id="isLogged">
      <a href="/week7/index.jsp">어쩔티비</a>
      <form action="logoutAction.jsp" id="logoutForm">
        <input type="submit" value="로그아웃" />
      </form>
      <a href="../Page/writePost.html" id="writePostBtn">글쓰기</a>
    </header>

    <h1>글 수정하기</h1>

    <form method="post" id="postUpdateForm">
      <label name="titleValue">제목</label>
      <input type="text" name="titleValue" id="titleInput" onchange="changeInput(event)"  required/>
      <br />

      <label name="contentValue">내용</label>
      <textarea name="contentValue" id="contentInput" onchange="changeInput(event)" required></textarea>
      <div class="btn" onclick="updatePostDB()">수정하기</div>
    </form>

    <script>
    const postDetail = <%=postDetail%>;
    const postId = <%=postId%>
    
    document.getElementById("titleInput").setAttribute("value",postDetail[0]);
    document.getElementById("contentInput").innerHTML = postDetail[1];

    function changeInput(e) { 
        e.target.setAttribute("value", e.target.value);       
    }

    function updatePostDB() {
        document.getElementById("postUpdateForm").action = "updatePostDBAction.jsp?postIdx="+postId;
        document.getElementById("postUpdateForm").submit();
    }

    </script>
  </body>
</html>
