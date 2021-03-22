<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- header.jsp -->
<c:import url="/WEB-INF/view/common/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>


<div class=container>
	<div class=row>
		<div class="col-lg-11 mx-auto">
			<h4> &nbsp; indexList </h4>

			<c:if test="${empty indexList }">
				<br>
				<h5>서버를 연결해주십시오.</h5>
			</c:if>
			
			<c:if test="${not empty indexList }">
				<span style=font-size:13px;>&nbsp; Index Service Total Ram :  ${indexList[indexList.size()-1].memory_quota}MB</span><br>
				<span style=font-size:13px;>&nbsp; Index Service RAM 사용량 : ${indexList[indexList.size()-1].memory_percent}% </span>
				<br><br>
			
				<table class="table table-hover" id=repoTable style="cursor:pointer;">
					
					<colgroup>
						<col width=30%>
						<col width=15%>
						<col width=20%>
						<col width=20%>
						<col width=10%>
					</colgroup>
					
					<thead>
						<tr >
							<th> 이름 </th>
							<th> 항목 수 </th>
							<th> data 크기 </th>
							<th> keyspace </th>
							<th> 상태 </th>
						</tr>
					</thead>
					
						<tbody>
					
							<c:forEach items="${indexList }" var="list" varStatus="status">
								
								<c:if test="${not empty list.name }">
									<tr onclick='trClick("${status.index }")'> 
										<td> ${list.name }</td>
										<td> ${list.items_count }</td>
										<td> ${list.data_size }KB</td>
										<td> ${list.keyspace }</td>
										<td> ${list.state }</td>
									</tr>
									
									
									
									<tr class=innerTR id="tr${status.index  }" >
										<td colspan=4 style=text-align:left;>정의: CREATE <c:if test="${list.is_primary eq true }" >PRIMARY </c:if>INDEX `${list.name }` ON `${list.keyspace }` 
											<c:if test="${list.index_key.size() > 0}"> 
											
												(
													<span id="column${status.index }"> </span>
												)
												
												<script>
													var a = '${list.index_key}';
													var json = JSON.parse(a);
													
													var columns= '';
													
													for(var i=0;i<json.length;i++){
														
														if(i ==0)
															columns = json[i];
														else
															columns += ','+json[i];
													}
													$('#column${status.index }').text(columns);
													
												</script>
											</c:if>
											<br>
											Storage Mode : ${list.using }
										</td>
									
									</tr>
									
									
									
								</c:if>
							</c:forEach>
						</tbody>
				</table>
				
				
			</c:if>
			

		</div>
	</div>
</div>



</body>
</html>