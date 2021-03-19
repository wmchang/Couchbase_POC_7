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
	img{
		width:15px;
		height:15px;
	}
	h5 {
		margin-top:15px;
	}
	input[type=text],input[type=password], select{
		width:60%;
	}
</style>

<script>

	function importRepository(){
		
 		if(!inputCheck($('#repositoryForm'))){
			alert('모든 항목을 입력해주세요.');
			return;
		} 
		
		let data = $('#repositoryForm').serialize();
		
		$.ajax({
			
			data: data,
			type: "post",
			url:"<%=request.getContextPath()%>/importRepository",
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
			
				<h4> &nbsp; Import Repository </h4>
				<br>
				
				<h5> ID </h5>
				<input type=text name=repositoryName placeholder="Repository 이름">
				
				<h5>저장소 위치</h5>
				<select name=StorageLocations>
					<option value=fileSystem>FileSystem</option>
				</select>
			
				<h5> Repository 상세 위치 </h5>
				<input type=text name=archive id=archive placeholder="파일 백업 위치">
				<img src="<%= request.getContextPath()%>/static/image/descriptionIcon.png"
				 title="해당 Repository의 id를 포함한 경로여야합니다."  >
				
			</div>
			
			<button type=button class="btn btn-primary" style=float:right onclick="importRepository();">추가</button>
			
		</form>
	
	</div>

</body>
</html>