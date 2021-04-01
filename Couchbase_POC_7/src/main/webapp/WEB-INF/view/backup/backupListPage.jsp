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
				<h4> &nbsp; Task History <span style=font-size:11px;>Total : ${taskList.size() }</span></h4>
				
				<button type=button class="btn btn-light" style=float:right; onclick="javascript:history.back();"> 뒤로가기 </button>
				<br><br>
				
				<table class="table table-hover" id=repoTable style="cursor:pointer; table-layout:fixed;word-break:break-all;">
					
					<colgroup>
						<col width=40%>
						<col width=15%>
						<col width=15%>
						<col width=40%>
						<col width=40%>
					</colgroup>
					
					<thead>
						<tr >
							<th> 이름 </th>
							<th> 타입 </th>
							<th> 결과 </th>
							<th> 시작시간 </th>
							<th> 종료시간 </th>
						</tr>
					</thead>
					
					<tbody>
						<c:if test="${empty taskList }">
							<tr>
								<td colspan=5 style=text-align:center;> 실행된 작업이 존재하지 않습니다.</td>
							</tr>
						</c:if>
						
						<c:if test="${not empty taskList }">
							<c:forEach items="${taskList }" var="list" varStatus="status">
							
							<tr onclick='trClick("${status.index }")'>
								<td>${list.task_name }</td>
								<td>${list.type }</td>
								<td>${list.status }</td>
								<td> ${list.start }  </td>
								<td> ${list.end }  </td>
							</tr>
							
							<tr style="display:none;" id="tr${status.index }" onmouseover="this.style.background='white'">
									<td colspan=6 id="jsonText${status.index }"><pre style=text-align:left;font-size:11px;width:100%;overflow:auto;></pre> </td>
							</tr> 
							
							<script>
							
								var obj = '${taskList[status.index]}';
								var pretty = JSON.stringify(JSON.parse(obj), null, 4);
								$('#jsonText${status.index } pre').html(pretty);
								
							</script>
							
								
							</c:forEach>
						</c:if>
					</tbody>
					
				</table>
				
		
			</div>
		</div>
	</div>

</body>
</html>