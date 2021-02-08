<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script>
	function addFunction(){
		
		var popupX = (window.screen.width/2)-(500/2);
		var popupY = (window.screen.height/2)-(500/2);
		var left = (screen.availWidth)-popupX;
		
		if( window.screenLeft < 0){
			left += window.screen.width*-1;
			}
			else if ( window.screenLeft > window.screen.width ){
			left += window.screen.width;
		}
		
		var document_window = window.open('addEventingFunction','팝업스','width=500, height=600, left='+left+', top='+popupY+', menubar=no, status=no, toolbar=no')
	}
</script>
</head>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>

</body>
</html>