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


/*  	$(document).ready(function(){
		
		$('#repoTable tbody tr').css("cursor","pointer");
		
		$('#repoTable tbody tr').click(function () {
			let trIndex = $(this).index();
			
			
			console.log(trIndex);
			
			
			
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
	
	});  */
	
	function addRepository(){
		
		window.open('newRepository','팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
		
	}
	
	function deleteRepository(repoName){
		
		if(!confirm('해당 Repository를 삭제하시겠습니까?'))
			return;
		
		let data = 'repositoryName='+repoName;
		
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
	
	function archiveRepository(repoName){
		
		if(!confirm('해당 Repository를 보관하시겠습니까? 보관된 저장소는 읽기 전용이며 이 작업을 취소할 수 없습니다.'))
			return;
		
		let data = 'repositoryName='+repoName;
		
		$.ajax({
			
			data:data,
			type:'post',
			url:"<%=request.getContextPath()%>/archiveRepository",
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
	
	function restoreRepository(repoName, state){
		
		let data = 'repositoryName='+repoName;
		data += '&state='+ state;
		
		window.open('restorePage?'+data,'팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');

	}
	
	function taskHistory(repoName, state){
		
		let data = 'repositoryName='+repoName;
		data += '&state='+ state;
		
		location.href="taskHistoryPage?"+data;

	}
	
	function backupExcute(repoName, state){
		
		if(!confirm('백업을 실행하시겠습니까?'))
			return;
		
		let full_backup = true;
		
		if(!confirm('전체 백업을 수행하시겠습니까? 취소를 누르면 증분 백업을 수행합니다.'))
			full_backup = false;
		
		let data = 'repositoryName='+repoName;
		data += '&state='+ state;
		data += '&full_backup='+ full_backup;

		$.ajax({
			
			data:data,
			type:'post',
			url:"<%=request.getContextPath()%>/backupExcute",
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
	
	
	function resumeRepository(repoName, state){
		
		let data = 'repositoryName='+repoName;
		data += '&state='+ state;

		$.ajax({
			
			data:data,
			type:'post',
			url:"<%=request.getContextPath()%>/resumeRepository",
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
			<c:if test="${empty activeList and empty archiveList}">
				<br>
				<h5> 서버를 연결해주십시오.</h5>
			</c:if>
			
			<c:if test="${not empty activeList or not empty archiveList}">
				<button type=button class="btn btn-primary" style=float:right; onclick="addRepository()"> Add Repository </button>
			</c:if>
			
			<c:if test="${not empty activeList}">
				<br><br>
				
				<h5> &nbsp; # 활성화되어있는 Repository </h5> <br>
				<table class="table table-hover" id=repoTable style="cursor:pointer;">
					
					<colgroup>
						<col width=20%>
						<col width=15%>
						<col width=20%>
						<col width=40%>
					</colgroup>
					
					<thead>
						<tr >
							<th> 이름 </th>
							<th> 버킷</th>
							<th> 플랜명 </th>
							<th> 상태 </th>
						</tr>
					</thead>
					
					<tbody>
					
						<!-- active 상태의 repository -->
						<c:forEach items="${activeList }" var="list" varStatus="status">
							
							<tr onclick='trClick("${status.index }")'> 
								<td> ${list.id }</td>
								<td> <c:if test="${list.bucket.name eq null }"> All Buckets</c:if> ${list.bucket.name }</td>
								<td> ${list.plan_name }</td>
								<td> ${list.nextStatus } <c:if test="${empty list.nextStatus }"> ${list.state }</c:if></td>
							</tr>
							
							<tr style="display:none;" id="tr${status.index }" onmouseover="this.style.background='white'">
								<td colspan=4 style=text-align:left;> 
									
									<table class="table table-sm" style="cursor:auto;">
										<tr>
											<td> 저장소 </td>
											<td> 상태 </td>
											<td> 백업</td>
											<td> 작업내용 </td>
											<td> 복구</td>
											<td> 보관</td>
											<c:if test="${list.state eq 'paused' }">
												<td> 실행 </td>
											</c:if>
										</tr>
										<tr>
											<td> ${list.archive }</td>
											<td> ${list.state }</td>
											<td> <button type=button class="btn btn-success" onclick="backupExcute('${list.id}','${list.state }')">Backup</button> </td>
											<td> <button type=button class="btn btn-light" onclick="taskHistory('${list.id}','${list.state }')">TaskHistory</button> </td>
											<td> <button type=button class="btn btn-light" onclick="restoreRepository('${list.id}','${list.state }')"> Restore</button></td>
											<td> <button type=button class="btn btn-warning" onclick="archiveRepository('${list.id}')">Archive</button></td>
											<c:if test="${list.state eq 'paused' }">
												<td><button type=button class="btn btn-primary" onclick="resumeRepository('${list.id}')">Resume</button></td>
											</c:if>
										</tr>
									</table>
								</td>
							</tr> 
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			
			<c:if test="${not empty archiveList }">
			
				<h5> &nbsp; # 보관된 Repository </h5> <br>
				<table class="table table-hover" id=repoTable style="cursor:pointer;">
					
					<colgroup>
						<col width=20%>
						<col width=15%>
						<col width=20%>
						<col width=40%>
					</colgroup>
					
					<thead>
						<tr >
							<th> 이름 </th>
							<th> 버킷</th>
							<th> 플랜명 </th>
							<th> 상태 </th>
						</tr>
					</thead>
					
					<tbody>
					
						<!-- archive 상태의 repository -->
						<c:forEach items="${archiveList }" var="list" varStatus="status">
							
							<tr onclick='trClick("${status.index + activeList.size() }")'> 
								<td> ${list.id }</td>
								<td> <c:if test="${list.bucket.name eq null }"> - </c:if> ${list.bucket.name }</td>
								<td> ${list.plan_name }</td>
								<td> ${list.state }</td>
							</tr>
							
							<tr style="display:none;" id="tr${status.index + activeList.size() }" onmouseover="this.style.background='white'">
								<td colspan=4 style=text-align:left;> 
									
									<table class="table  table-sm" style=cursor:auto>
										<tr>
											<td> 저장소 </td>
											<td> 상태 </td>
											<td> 작업내역 </td>
											<td> 복구 </td>
											<td> 삭제 </td>
										</tr>
										<tr>
											<td> ${list.archive }</td>
											<td> ${list.state }</td>
											<td> <button type=button class="btn btn-light" onclick="taskHistory('${list.id}','${list.state }')">taskHistory</button> </td>
											<td> <button type=button class="btn btn-light" onclick="restoreRepository('${list.id}','${list.state }')"> Restore</button></td>
											<td> <button type=button class="btn btn-warning" onclick="deleteRepository('${list.id}')">Delete</button> </td>
										</tr>
									</table>
								</td>
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