<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import> 
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style>
	h5{
		margin-top:15px;
	}

</style>

<script>

	function addRepository(){
		
 		if(!inputCheck($('#repositoryForm'))){
			alert('모든 항목을 입력해주세요.');
			return;
		} 
		
		let data = $('#repositoryForm').serialize();
		
		$.ajax({
			
			data: data,
			type: "post",
			url:"<%=request.getContextPath()%>/addNewRepository",
			error: function(xhr, status, error){
				
				alert(error);
			},
			success: function(data) {
				
				alert(data);
				
				if(data.includes('정상')){
					window.close();
					opener.location.reload();
				}
			}
		});
		
	}

</script>
</head>
<body>

<div class=container>
	<br>
	<form id=repositoryForm>
		
		<div id=taskDiv>
		
			<h4> &nbsp; Repository 생성 </h4>
			<br>
			<h5> Plan</h5>
			<select name=planName>
				<c:forEach items="${planList }" var="list">
					<option	 value="${list }"> ${list } </option>
				</c:forEach>
			</select>
			
			<h5> ID </h5>
			<input type=text name=repositoryName placeholder="Repository 이름">
			
			<h5> Couchbase Bucket</h5>
			<select name=bucketName>
				<option value=""> All Buckets </option>
				
				<c:forEach items="${bucketList }" var="list">
					<option value="${list }"> ${list } </option>
				</c:forEach>
			</select>
			
			<h5>저장소 위치</h5>
			<select name=StorageLocations>
				<option value=fileSystem>FileSystem</option>
			</select>
		
			<h5> 상세 위치 </h5>
			<input type=text name=archive id=archive placeholder="파일 백업 위치">
		
		</div>
		
		<button type=button class="btn btn-primary" style=float:right onclick="addRepository();">추가</button>
		
		<br>
	</form>
</div>

</body>
</html>