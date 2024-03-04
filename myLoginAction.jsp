<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>

<%
    String userId = request.getParameter("userIdInput");
    
      session.setAttribute("userId", userId);
        response.sendRedirect("index.jsp"); // 로그인 성공 시 이동할 페이지

    // 여기에서는 간단히 하드코딩된 값으로 로그인을 처리합니다.
    // if (userId) {
    //     // 로그인이 성공하면 세션에 사용자 정보를 저장합니다.
    //     session.setAttribute("userIdx", userId);
    //     response.sendRedirect("index.jsp"); // 로그인 성공 시 이동할 페이지
    // } else {
    //     out.println("Invalid username or password. Please try again."); // 로그인 실패 시 메시지 출력
    // }
%>
