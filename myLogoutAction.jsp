<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>

<%
    // 세션에서 사용자 정보를 제거하여 로그아웃합니다.
    session.removeAttribute("userId");
    // session.invalidate();
    response.sendRedirect("index.jsp"); // 로그아웃 후 로그인 페이지로 이동
%>