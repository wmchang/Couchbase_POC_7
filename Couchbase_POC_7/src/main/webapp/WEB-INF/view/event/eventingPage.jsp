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
						    <col width="5%" />
						    <col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th>Function 이름</th>
								<th>Source KeySpace</th>
								<th>Target KeySpace</th>
								<th>상태</th>
								<th>설명</th>
							</tr>
						</thead>
					
						<tbody>
							<c:forEach items="${functionList }" var="list">
								<tr>
									<td>${list.functionName }</td>
									
									<td>${list.bucketInfo.buckets[0].bucket_name }.
									${list.bucketInfo.buckets[0].scope_name }.
									${list.bucketInfo.buckets[0].collection_name }</td>
									
									<td>${list.bucketInfo.buckets[1].bucket_name }.
									${list.bucketInfo.buckets[1].scope_name }.
									${list.bucketInfo.buckets[1].collection_name }</td>
									
									<c:choose>
										<c:when test="${list.settings.deployment_status eq 'false'}">
											<td>undeployed</td>
										</c:when>
										<c:when test="${list.settings.deployment_status eq 'true'}">
											<td>deployed</td>
										</c:when>
									</c:choose>
									
									<td>${list.settings.description }</td>
									
								</tr>
							</c:forEach>
						</tbody>
					</table>
					
				</c:if>
			
				<c:if test="${not empty message }">
				
					${message }
				</c:if>
			
			</div>
		</div>
	</div>
	

</body>
</html>