<%@ page language="java" contentType="text/html" pageEncoding="utf-8" %> 
<%@ page import="java.sql.DriverManager" %> <!--커넥터파일을 찾는 라이브러리-->
<%@ page import = "java.sql.Connection" %> <!-- db에 연결하는 라이브러리-->
<%@ page import="java.sql.PreparedStatement" %> <!--sql을 전송하는 라이브러리 -->
<%@ page import="java.sql.ResultSet" %> <!-- table데이터를 저장하는 라이브러리. select할때 필요하다 -->
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("utf-8"); 
String postIdxValue = request.getParameter("postIdx"); 
String postId = "\""+postIdxValue+"\"";
String userIdx =  "\""+((String) session.getAttribute("userIdx")) +"\"" ;

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



// 여기서부터는 다시 댓글 불러오는 과정

sql = "SELECT comment.idx, comment.writer_idx, account.nickname, comment.time, comment.content FROM comment JOIN account ON comment.writer_idx = account.idx WHERE comment.post_idx = ? ORDER BY comment.idx DESC;";
query = connect.prepareStatement(sql);// sql문을 가지고 전송할 준비
query.setString(1,postIdxValue);
result = query.executeQuery();

ArrayList<ArrayList<String>> commentList = new ArrayList<ArrayList<String>>();

while(result.next())
{
    ArrayList<String> commentData = new ArrayList<String>();
    String commentIdx = result.getString(1);
    String commentWriterIdx = result.getString(2);
    String commentNickname = result.getString(3);
    String commentTime = result.getString(4);
    String commentContent = result.getString(5);
    
    commentData.add("\""+commentIdx+"\"");
    commentData.add("\""+commentWriterIdx +"\"");
    commentData.add("\""+commentNickname+"\""); 
    commentData.add("\""+commentTime+"\"");
    commentData.add("\""+commentContent+"\"");

    if(userIdx.equals("\""+commentWriterIdx +"\""))
    {
        commentData.add("true");
    }else{
        commentData.add("false");
    }

    commentList.add(commentData);
}

%>


<!DOCTYPE html>
<html lang="kr">

  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/week7/global.css">
    <title>제목</title>
    <script src="../js/displayComment.js" defer></script>
  </head>

  <body>
    <header id="isNotLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <a href="../Page/login.html" id="loginBtn">로그인</a>
        <a href="../Page/signup.html" id="signupBtn">회원가입</a>
    </header>

   <header id="isLogged">
        <a href="/week7/index.jsp">어쩔티비</a>
        <form action="logoutAction.jsp" id="logoutForm">
            <input type="submit" value="로그아웃" />
        </form>
        <a href="mypageAction.jsp" id="mypageBtn">마이페이지</a>
        <a href="../Page/writePost.html" id="writePostBtn">글쓰기</a>
    </header>

    <section id="postSection">
        <form id="postUpdateAndDelete" method="post">
            <div class="btn" onclick="updatePost()">글 수정하기</div>
            <div class="btn" onclick="deletePost()">글 삭제하기</div>
        </form>
        <div class="post">
            <h3 id="postTitle">타이틀</h3>
            <h4 id="writerNickname">작성자</h4>
            <p id="postContent">내용</p>
        </div>
    </section>

    <section id="commentSection">
        <form method="post" action="writeCommentAction.jsp" id="writeComment">
            댓글쓰기
            <br/>
            <label name="commentContentValue">내용</label>
            <textarea id="commentTextarea" class="commentTextarea" name="commentContentValue" required></textarea>
            <div class="btn" onclick="writeComment()">댓글 쓰기</div>
        </form>
    </section>

    <script>
    const userIdx = <%=userIdx%>
    if(userIdx === "null")
    {
        let isLoggedHeader = document.getElementById("isLogged");
        isLoggedHeader.style.display="none";
    }else {
        let isNotLoggedHeader = document.getElementById("isNotLogged");
        isNotLoggedHeader.style.display = "none";
    }

    const postId = <%=postId%>

    function updatePost() {
        document.getElementById("postUpdateAndDelete").action =
            "updatePostAction.jsp?postIdx="+postId;
        document.getElementById("postUpdateAndDelete").submit();
    }

      function deletePost() {
        document.getElementById("postUpdateAndDelete").action =
          "deletePostAction.jsp?postIdx="+postId;
        document.getElementById("postUpdateAndDelete").submit();
    }

      function writeComment() {
        if(userIdx === "null") 
        {
            alert("로그인 후 댓글을 작성할 수 있습니다.");
        } else {

            if(document.getElementById("commentTextarea").value.trim() === "")
            {
                alert("내용을 입력해주세요.");
            } else {
            document.getElementById('writeComment').action = "writeCommentAction.jsp?postIdx="+postId;
            document.getElementById('writeComment').submit();
            }
        }
        
    }

    const postDetail = <%=postDetail%>;
    document.getElementById("postTitle").innerText = "제목: " + postDetail[1];
    document.getElementById("writerNickname").innerText = "글쓴이: " + postDetail[4];
    document.getElementById("postContent").innerText=postDetail[3];

    
    

    const javaCommentList = <%=commentList%>;

    const commentList = [];
    for(let i = 0; i < javaCommentList.length; i++) {
        const comment = {
            id: javaCommentList[i][0],
            writerIdx:javaCommentList[i][1],
            nickname: javaCommentList[i][2],
            time: javaCommentList[i][3],
            content: javaCommentList[i][4],
            myComment:javaCommentList[i][5]
        };
        
        commentList.push(comment);
    }

    function updateComment(e, id, value) {
        // 우리가 수업 때 배운 방법 ( from 태그 안에 input으로 모든 값이 준비 되어야 함 )
        e.target.parentElement.action = "updateCommentAction.jsp"
        e.target.parentElement.submit()

        // 새로 알게 된 방법 ( 기존에 사용하던 form 태그 안의 input과는 같이 사용할 수 없음 )
        /*
        window.location.href = `updateCommentAction.jsp?
            postIdx=${postId}&
            commentIdx=${id}&
            commentContent=${value}
        `;
        */    
    }

    function deleteComment(e, id) {
    e.target.parentElement.action = "deleteCommentAction.jsp?postIdx="+postId+"&commentIdx="+id;
    e.target.parentElement.submit();
    
    // window.location.href="deleteCommentAction.jsp?postIdx="+postId+"&commentIdx="+id;
    }


    function displayCommentSection() {
        commentList.forEach((comment) => {

            const commentForm = document.createElement("form");
            commentForm.setAttribute("class", "comment");

            const h4 = document.createElement("h4");
            h4.innerHTML = comment.nickname;
            commentForm.appendChild(h4);

            const h5 = document.createElement("h5");
            h5.innerHTML = comment.time;
            commentForm.appendChild(h5);

            const p = document.createElement("p");
            p.innerText = comment.content;
            commentForm.appendChild(p);

            // 댓글을 update할때 쓰이는 textarea (처음에 로드될때는 보이지 않음)
            const updateInput = document.createElement('textarea');
            updateInput.style.display='none';
            updateInput.className="commentTextarea";
            updateInput.name = 'commentContent';
            updateInput.value = comment.content;
            commentForm.appendChild(updateInput);

            // 댓글을 update -> save할때 쓰이는 버튼 (처음에 로드될때는 보이지 않음)
            const saveDiv = document.createElement('div');
            saveDiv.id = 'saveBtn';
            saveDiv.className='btn';
            saveDiv.innerHTML="저장";
            saveDiv.style.display='none';
            saveDiv.addEventListener('click', function (e) {
                const clickedComment = e.target.parentElement;
                const updatedCommentContent = clickedComment.querySelector('.commentTextarea').value;
                updateComment(e, comment.id, updatedCommentContent);
            })
            commentForm.appendChild(saveDiv);

            // 내가 작성한 댓글일 경우 수정, 삭제 버튼이 보이도록
            if(comment.myComment) {
                const updateDiv = document.createElement("div");
                updateDiv.className = "btn";
                updateDiv.innerHTML = "수정";
                updateDiv.addEventListener("click", function (e) {
                    const clickedComment = e.target.parentElement;
                    clickedComment.querySelector('p').style.display='none';
                    clickedComment.querySelector('div').style.display='inline-block';
                    clickedComment.querySelector('.commentTextarea').style.display='block';
                    e.target.style.display='none';
                });
                commentForm.appendChild(updateDiv);

                const deleteDiv = document.createElement("div");
                deleteDiv.className = "btn";
                deleteDiv.innerHTML = "삭제";
                deleteDiv.addEventListener('click', function(e) {
                    deleteComment(e, comment.id);
                })
                commentForm.appendChild(deleteDiv);


                // 데이터 통신을 위한 태그 ( 게시글 idx )
                const postIdxP = document.createElement("input");
                postIdxP.value = postId;
                postIdxP.name = "postIdx"
                postIdxP.style.display = "none"
                commentForm.appendChild(postIdxP);

                // 데이터 통신을 위한 태그 ( 댓글 idx )
                const commentIdxP = document.createElement("input");
                commentIdxP.value = comment.id;
                commentIdxP.name = "commentIdx"
                commentIdxP.style.display = "none"
                commentForm.appendChild(commentIdxP);            
            }

            const commentSection = document.getElementById("commentSection");
            commentSection.appendChild(commentForm);

        });
    }
   
    displayCommentSection();



    </script>
  </body>
</html>

