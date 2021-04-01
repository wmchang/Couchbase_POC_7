<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- header.jsp -->
<c:import url="/WEB-INF/view/common/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

<script>
	
	function deletePlan(planName){
		
		if(!confirm('삭제하시겠습니까?'))
			return;
			
		let data = 'planName='+planName;
		
		$.ajax({
			
			data:data,
			type:'post',
			url:"<%=request.getContextPath()%>/deletePlan",
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
	
	function addPlan(){
		window.open('newPlan','팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
	}

	
</script>
</head>
<body>


<div class=container>
	<div class=row>
		<div class="col-lg-11 mx-auto">
			<h4> &nbsp; Plans</h4>
			
			<c:if test="${empty planList}">
				<br>
				<h5> 서버를 연결해주십시오.</h5>
			</c:if>
			
			
			<c:if test="${not empty planList}">
				<button type=button class="btn btn-primary" style=float:right; onclick="addPlan()"> Add Plan </button>
				<br><br>
				
				<table class="table table-hover" id=planTable  style=cursor:pointer>
					
					<colgroup>
						<col width=30%>
						<col width=40%>
						<col width=10%>
					</colgroup>
					
					<thead>
						<tr>
							<th> 이름 </th>
							<th> 서비스 </th>
						</tr>
					</thead>
					
					<tbody>
						<c:forEach items="${planList }" var="list" varStatus="status">
							
							<tr onclick='trClick("${status.index }")'> 
								<td> ${list.name }</td>
								<td> 
									<c:choose>
										<c:when test = "${list.services eq null}">
											Data, Index, Views, Search, Eventing, analytics
										</c:when>
										<c:otherwise>
											${list.services }
										</c:otherwise>
									</c:choose>
								</td>
								
							</tr>
							<tr class=innerTR id="tr${status.index }" >
								<td colspan=4 style=text-align:left;> 
									&nbsp; 설명 : ${list.description } 
									<br><br>
									
									<table class="table  table-sm"  style=cursor:auto>
										<tr>
											<td> 작업 이름 </td>
											<td> task 유형 </td>
											<td> 스케줄 </td>
											<td> 옵션 </td>
										</tr>
										<c:forEach items="${list.tasks }" var="tasks">
											<tr>
												<td>${tasks.name } </td>
												<td>${tasks.task_type } </td>
												<td>매 ${tasks.schedule.frequency } ${tasks.schedule.period } ${tasks.schedule.time } 마다 </td>
												<td><c:choose>
														<c:when test = "${tasks.full_backup eq 'true'}">
															Full-backup
														</c:when>
														<c:otherwise>
															-
														</c:otherwise>
													</c:choose>
												</td>
											</tr>
										</c:forEach>
									</table>
									
									<button type=button class="btn btn-warning" onclick="deletePlan('${list.name}')" style=float:right;>Delete</button>
									
								
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