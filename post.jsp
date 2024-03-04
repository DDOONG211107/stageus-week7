<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String postIdxValue = request.getParameter("postIdx"); 

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT post.idx, post.title, post.time, post.content, account.nickname FROM post JOIN account ON post.writer_idx = account.idx WHERE post.idx = ?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,postIdxValue);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀
result.next(); // 꼭 한번 next()를 해야 함
//4. 데이터 정제 (프론트엔드에서 사용하기 쉽게 여기에서 2차원 리스트로 편집해서 전달)

ArrayList<String> postDetail = new ArrayList<String>(); // jsp에서 리스트 만드는 방법
// ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();

    String idx = result.getString(1);
    String title = result.getString(2);
    String time = result.getString(3);
String content = result.getString(4);
String writer = result.getString(5); 
    postDetail.add("\""+idx+"\"");
    postDetail.add("\""+title+"\"");
    postDetail.add("\""+time+"\"");
postDetail.add("\""+content+"\"");
    postDetail.add("\""+writer+"\"");



// jsp에서는 자동으로 db 커넥션은 끊어짐 (따로 close는 필요x)
String user =  "\""+((String) session.getAttribute("userIdx")) +"\"" ;

%>





<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>제목</title>
  </head>
  <body>
  <header id="isNotLogged">
    <a href="./Page/login.html" id="loginBtn">로그인</a>
    <a href="./Page/signup.html" id="signupBtn">회원가입</a>
    </header>
    <header id="isLogged">
      <form action="./Action/logoutAction.jsp" id="logoutForm">
        <input type="submit" value="로그아웃" />
      </form>
    </header>
    <h3 id="postTitle">타이틀</h3>
    <h4 id="writerNickname">작성자</h4>
    <p id="postContent">내용</p>

    <script>
    const postDetail = <%=postDetail%>;
    console.log(postDetail);
    document.getElementById("postTitle").innerText=postDetail[1];
    document.getElementById("writerNickname").innerText=postDetail[4];
    document.getElementById("postContent").innerText=postDetail[3];

    const userIdx = <%=user%>
    console.log("js세션 "+userIdx);
    if(userIdx === "null")
    {
        console.log('아직 세션 없음');
        let isLoggedHeader = document.getElementById("isLogged");
        isLoggedHeader.style.display="none";
        // document.getElementById("userId").innerText="아직 로그인되지 않았슴!";
        
    }else {
        let isNotLoggedHeader = document.getElementById("isNotLogged");
        isNotLoggedHeader.style.display = "none";
        // document.getElementById("userId").innerText="현재 로그인한 유저의 idx: "+userIdx;
        
        
    }

</script>
  </body>
</html>

