<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

<script>


	function addFunction(){
		
		let win = window.open('newEventFunction','팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
	}
	
	function deploy(functionName){
		
		$.ajax({
			
			url:"<%=request.getContextPath()%>/deployEventFunction?functionName="+functionName,
			type:"post",
			error : function(xhr, status, error){
				alert(error);
			},
			success : function(data){
				
				alert(data);
				if(data.includes('정상'))
					location.reload();
			}
		});
		
	}
	
	function undeploy(functionName){
		
		$.ajax({
			
			url:"<%=request.getContextPath()%>/undeployEventFunction?functionName="+functionName,
			type:"post",
			error : function(xhr, status, error){
				alert(error);
			},
			success : function(data){
				
				alert(data);
				if(data.includes('정상'))
					location.reload();
			}
		});
	}
	
	function editEventFunction(functionName){
		
		let win = window.open('editEventFunction?functionName='+functionName,'팝업스','width=700, height=600, left=2500, top=1, menubar=no, status=no, toolbar=no');
		
	}
	
</script>

</head>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container>
		<div class=row>
			<div class="mx-auto col-lg-10" style="text-align:center;" >
				<c:if test="${not empty functionList }">
					<div>
						<button class="btn btn-primary" style=float:right; onclick="addFunction();">Add Function</button>
					</div>
					<br><br>
					<table class="table table-striped table-hover">
						<colgroup>
						    <col width="15%" />
						    <col width="20%" />
						    <col width="20%" />
						    <col width="20%" />
						    <col width="5%" />
						    <col width="5%" />
						    <col width="5%" />
						</colgroup>
						<thead>
							<tr>
								<th>Function 이름</th>
								<th>Source KeySpace</th>
								<th>Meta KeySpace</th>
								<th>설명</th>
								<th>상태</th>
								<th></th>
							</tr>
						</thead>
					
						<tbody>
							<c:forEach items="${functionList }" var="list">
								<tr>
									<td><a href=# onclick="editEventFunction('${list.functionName }')">${list.functionName }</a></td>
									
									<td>${list.bucketInfo.source_bucket }.
									${list.bucketInfo.source_scope }.
									${list.bucketInfo.source_collection }</td>
									
									<td>${list.bucketInfo.metadata_bucket }.
									${list.bucketInfo.metadata_scope }.
									${list.bucketInfo.metadata_collection }</td>
									
									<td>${list.settings.description }</td>
									
									
									<c:choose>
										<c:when test="${list.settings.deployment_status eq 'false'}">
											<td>undeployed</td>
											<td><button class="btn btn-primary" onclick="deploy('${list.functionName }')">deploy</button></td>
										</c:when>
										<c:when test="${list.settings.deployment_status eq 'true'}">
											<td>deployed</td>
											<td><button class="btn btn-warning" onclick="undeploy('${list.functionName }')">undeploy</button></td>
										</c:when>
									</c:choose>
									
								</tr>
							</c:forEach>
						</tbody>
					</table>
					
				</c:if>
			
				<c:if test="${not empty message }">
				
					${message }
				</c:if>
				
				<c:if test="${empty message }">
					<div>
						<button class="btn btn-primary" style=float:right; onclick="addFunction();">Add Function</button>
					</div>
				</c:if>
			
			</div>
		</div>
	</div>
	

</body>
</html>