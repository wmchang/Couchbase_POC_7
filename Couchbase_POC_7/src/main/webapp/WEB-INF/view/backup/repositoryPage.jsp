<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- header.jsp -->
<c:import url="/WEB-INF/view/common/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

<script>


	let lastToggle ='';
	let lastToggleIndex = '';
	
	
	$(document).ready(function(){
		
		$('#planTable tbody tr').css("cursor","pointer");
		
		$('#planTable tbody tr').click(function () {
			let trIndex = $(this).index();
			
			if(trIndex != 0)
				trIndex /= 2;
			
			if(lastToggle != ''){
				
				if( Math.floor(trIndex) == lastToggleIndex){
					if( lastToggle.is(':visible')){
						lastToggle.toggle();
						return;
					}
				}
				else if(lastToggle.is(':visible'))
					lastToggle.toggle();
			}
			
			lastToggle = $('#tr'+trIndex);
			lastToggle.toggle();
			lastToggleIndex =  Math.floor(trIndex);
			
		});
	
	});


	function addRepository(){
		
		window.open('newRepository','팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
		
	}
	
	function deleteRepository(repoName){
		
		
		
		let data = 'repositoryName='+repoName;
		
		console.log(data);
		
		$.ajax({
			
			data:data,
			type:'post',
			url:"<%=request.getContextPath()%>/deleteRepository",
			error : function(xhr, status, error) {
				alert(error);
			},
			success : function(data){
				alert(data);
				
				if(data.includes('완료'))
					location.reload();
			}
		});
		
	}

</script>
</head>
<body>


<div class=container>
	<div class=row>
		<div class="col-lg-11 mx-auto">
			<h4> &nbsp; Repositories </h4>
			
			<c:if test="${empty repoList}">
				<h5> 서버를 연결해주십시오.</h5>
			</c:if>
			

			

			
			
			<c:if test="${not empty repoList}">
				<button type=button class="btn btn-primary" style=float:right; onclick="addRepository()"> Add Repository </button>
				<br><br>
				<table class="table table-hover" id=planTable>
					
					<colgroup>
						<col width=20%>
						<col width=15%>
						<col width=20%>
						<col width=40%>
						<col width=10%>
					</colgroup>
					
					<thead>
						<tr>
							<th> 이름 </th>
							<th> 버킷</th>
							<th> 플랜명 </th>
							<th> 상태 </th>
							<th>  </th>
						</tr>
					</thead>
					
					<tbody>
						<c:forEach items="${repoList }" var="list" varStatus="status">
							
							<tr> 
								<td> ${list.id }</td>
								<td> <c:if test="${list.bucket.name eq null }"> All Buckets</c:if> ${list.bucket.name }</td>
								<td> ${list.plan_name }</td>
								<td> ${list.nextStatus }</td>
								<td> <button type=button class="btn btn-warning" onclick="deleteRepository('${list.id}')">Delete</button> </td>
							</tr>
							
							
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			
			
			
		</div>
	</div>
</div>	

</body>
</html>