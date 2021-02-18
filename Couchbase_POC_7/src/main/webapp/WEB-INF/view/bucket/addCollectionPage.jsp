<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import>
<script>
	function createCollection(bucketName, scopeName){
		
		if(!inputCheck($('#collectionForm'))){
			alert('모든 값을 채워주십시오.');
			return;
		}
		
		let data = $('#collectionForm').serialize();
		
		$.ajax({
			url:"<%= request.getContextPath() %>"+"/createCollection",
			type:"post",
			data:data,
			error : function(xhr, status, error){
				alert(error);
			},
			success : function(data){
				alert(data);
				if(data.includes("생성")){
					window.close();
					opener.location.reload();
				}
			}
		});
	}
</script>
</head>
<body>

	<div class=container style="margin:50 0 10 10px;">
		<h4> &nbsp; Create Scope </h4><br>
	
		<form id=collectionForm method=post action="<%=request.getContextPath() %>/addCollection" style="text-align:center;">	
			<div>
				<label>bucketName:</label><br>
				<input type=text name=bucketName readonly value="${bucketName }">
			</div>
			<div>
				<label>scopeName:</label><br>
				<input type=text name=scopeName readonly value="${scopeName }">
			</div>
			<div>
				<label>bucketName:</label><br>
				<input type=text name=collectionName>
			</div>
			<br>
			<button type="button" class="btn btn-primary float-right" onclick="createCollection();">생성</button>
		
		</form>
	</div>

</body>
</html>