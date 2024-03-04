<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>
<%@ page session="true" %>

<%
request.setCharacterEncoding("utf-8"); 
String userIdx =  "\""+((String) session.getAttribute("userIdx")) +"\"" ;

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT post.idx, post.title, account.nickname FROM post JOIN account ON post.writer_idx = account.idx ORDER BY post.idx DESC;";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀

//4. 데이터 정제 (프론트엔드에서 사용하기 쉽게 여기에서 2차원 리스트로 편집해서 전달)

ArrayList<ArrayList<String>> postList = new ArrayList<ArrayList<String>>();

while(result.next())
{
    ArrayList<String> data = new ArrayList<String>();

    String idx = result.getString(1);
    String title = result.getString(2);
    String nickname = result.getString(3);

    data.add("\""+idx+"\"");
    data.add("\""+title+"\"");
    data.add("\""+nickname+"\"");
    postList.add(data);
}

%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="./global.css">
    <title>어쩔티비</title>
</head>

<body>

    <header id="isNotLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <a href="./Page/login.html" id="loginBtn">로그인</a>
        <a href="./Page/signup.html" id="signupBtn">회원가입</a>
    </header>

    <header id="isLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <form action="./Action/logoutAction.jsp" id="logoutForm">
            <input type="submit" value="로그아웃" />
        </form>
        <a href="./Action/mypageAction.jsp" id="mypageBtn">마이페이지</a>
        <a href="./Page/writePost.html" id="writePostBtn">글쓰기</a>
    </header>

    <h1>게시글 목록</h1>
    <section id="postList">
        <div class="postLink">
            <span class="postNum">글 번호</span>
            <span class="postTitle">글 제목</span>
            <span class="postWriter">글쓴이</span>
        </div>
    </section>

    <script>
    const postList = <%=postList%>;
    
    let postListElement = document.getElementById('postList');
    for(let i=0; i<postList.length;i++)
    {
        const post = document.createElement('div');
        post.className='postLink';

        const postNumElement = document.createElement('span');
        postNumElement.className='postNum';
        postNumElement.innerText = postList[i][0];
        post.appendChild(postNumElement);

        const postTitleElement = document.createElement('a');
        postTitleElement.className='postTitle';
        postTitleElement.innerText = postList[i][1];
        postTitleElement.setAttribute('href',"./Action/postAction.jsp?postIdx="+postList[i][0]);
        post.appendChild(postTitleElement);

        const postWriterElement = document.createElement('span');
        postWriterElement.className='postWriter';
        postWriterElement.innerText = postList[i][2];
        post.appendChild(postWriterElement);

        postListElement.appendChild(post);
    }

    
    const userIdx = <%=userIdx%>;
    if(userIdx === "null") {
        console.log('아직 세션 없음');
        let isLoggedHeader = document.getElementById("isLogged");
        isLoggedHeader.style.display="none";        
    } else {
        let isNotLoggedHeader = document.getElementById("isNotLogged");
        isNotLoggedHeader.style.display = "none";    
    }

    </script>

</body>
</html>
