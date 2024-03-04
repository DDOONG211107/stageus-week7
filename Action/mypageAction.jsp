<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String userIdx = (String) session.getAttribute("userIdx");

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM account WHERE idx = ?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,userIdx);

// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀
result.next(); // 꼭 한번 next()를 해야 함

//4. 데이터 정제 (프론트엔드에서 사용하기 쉽게 여기에서 2차원 리스트로 편집해서 전달)
ArrayList<String> userDetail = new ArrayList<String>(); 

String idx = result.getString(1);
String id = result.getString(2);
String email = result.getString(4);
String nickname = result.getString(6);
String password = result.getString(3); 

userDetail.add("\""+idx+"\"");
userDetail.add("\""+id+"\"");
userDetail.add("\""+email+"\"");
userDetail.add("\""+nickname+"\"");
userDetail.add("\""+password+"\"");


%>

<!DOCTYPE html>
<html lang="kr">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../global.css" />
    <title>어쩔티비 마이페이지</title>
  </head>
  <body>
  
    <header id="isLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <form action="logoutAction.jsp" id="logoutForm">
            <input type="submit" value="로그아웃" />
        </form>
        <a href="mypageAction.jsp" id="mypageBtn">마이페이지</a>
        <a href="../Page/writePost.html" id="writePostBtn">글쓰기</a>
    </header>

    <h1>마이페이지</h1>
    <aside>
        <ul>
            <a href="mypageAction.jsp">마이페이지</a>
            <a href="../Page/accountRemove.html">회원탈퇴</a>
        </ul>
    </aside>

    <form id="mypageForm" method="post">
      <div>
        <label name="userIdValue">id</label>
        <input type="text" id="userIdInput" name="userIdValue" required
        onchange="changeInput(event)"/>
      </div>
      <div>
        <label name="userEmailValue">이메일</label>
        <input type="text" id="userEmailInput" name="userEmailValue" onchange="changeInput(event)" required/>
      </div>
      <div>
        <label name="userNicknameValue">닉네임</label>
        <input type="text" id="userNicknameInput" name="userNicknameValue" 
        onchange="changeInput(event)" required />
      </div>
      <div>
        <label name="userPwValue">비밀번호</label>
        <input type="password" id="userPasswordInput" name="userPasswordValue" onchange="changeInput(event)" required/>
      </div>
      <div class="btn" id="mypageUpdateBtn" onclick="mypageUpdate()">수정</div>
    </form>

    <script>
    const userDetail = <%=userDetail%>;
    
    document.getElementById("userIdInput").setAttribute("value",userDetail[1]);
    document.getElementById("userEmailInput").setAttribute("value",userDetail[2]);
    document.getElementById("userNicknameInput").setAttribute("value",userDetail[3]);
    document.getElementById("userPasswordInput").setAttribute("value",userDetail[4]);
    
    function changeInput(e) {
        e.target.setAttribute("value", e.target.value);
    }

    function mypageUpdate() {

        if (
            document.getElementById("userIdInput").value.trim() == "" ||
            document.getElementById("userEmailInput").value.trim() == "" ||
            !document.getElementById("userEmailInput").value.includes("@") ||
            document.getElementById("userNicknameInput").value.trim() == "" ||
            document.getElementById("userPasswordInput").value.trim() == "" 
        ) {
            alert("값을 올바르게 입력해주세요.");
        } else {
            document.getElementById("mypageForm").action =
            "../Action/mypageUpdateAction.jsp";
            document.getElementById("mypageForm").submit();
        }
    
    }

</script>
  </body>
</html>
