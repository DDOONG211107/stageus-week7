<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String idValue = request.getParameter("id_value"); 
String pwValue = request.getParameter("pw_value"); 

//이제 여기에 db통신하고 결과를 정제하면됨

//1. db통신
Class.forName("com.mysql.jdbc.Driver"); // connector파일을 찾아오는 것
Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/community","admin","1234"); // 데이터베이스에 연결하는 것

//2. sql 작성
String sql = "SELECT * FROM stageusaccount WHERE id=? AND pw=?";
PreparedStatement query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,idValue);
query.setString(2,pwValue);



// 3. sql 전송
ResultSet result = query.executeQuery(); // select일때는 executeQuery()를 씀

// result.next();
// result.getString(1); // 1번 row의 id값을 가져옴
// result.getString(2); // 1번 row의 pw값을 가져옴

//4. 데이터 정제 (프론트엔드에서 사용하기 쉽게 여기에서 2차원 리스트로 편집해서 전달)

// ArrayList<String> list = new ArrayList<String>(); // jsp에서 리스트 만드는 방법
ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();

while(result.next())
{
    ArrayList<String> data = new ArrayList<String>();
    String id = result.getString(1);
    String pw = result.getString(2);
    String name = result.getString(3);
    data.add("\""+id+"\"");
    data.add("\""+pw+"\"");
    data.add("\""+name+"\"");
    list.add(data);
}


// jsp에서는 자동으로 db 커넥션은 끊어짐 (따로 close는 필요x)

// 과제: 완성해오기... + session 적용해오기
%>

<script>
    var list = <%=list%>;
    console.log(list);
</script>



<head> </head>
<body>
  <h1>로그인액션입니다</h1>
  <p><%=idValue%></p>
  <p><%=pwValue%></p>
</body>
