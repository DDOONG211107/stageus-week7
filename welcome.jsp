<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome</h2>
    <% 
        // 세션에서 현재 로그인된 사용자 정보를 가져옵니다.
        String userId = (String) session.getAttribute("userIdx");
        
        // 사용자 정보가 null이 아니라면, 즉, 사용자가 로그인되어 있다면 해당 사용자의 이름을 환영 메시지와 함께 표시합니다.
        if(username != null) { %>
            <p>Hello, <%= username %>! You are currently logged in.</p>
            <form action="logout.jsp" method="post">
                <input type="submit" value="Logout">
            </form>
        <% } else { %>
            <p>You are not currently logged in.</p>
            <a href="login.jsp">Login</a>
        <% } %>
</body>
</html>
