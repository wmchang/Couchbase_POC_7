<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- header.jsp -->
<c:import url="/WEB-INF/view/common/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<%
int trNum = 0;

%>
<script>

	let yetTable = 'taskTable';
	function changeList(chk){
		
		$('input[id='+chk.id+']').parent().css('background-color','white');
		$(chk).parent().css('background-color','#669ee0');
		
		
		$('#'+yetTable).css('display','none');
		yetTable = chk.value+'Table';
		$('#'+yetTable).css('display','');
		
		if(yetTable == 'taskTable')
			$('#total').html("Total : ${taskList.size()}");
		else
			$('#total').html("Total : ${backupList.backups.size()}");
		
	}

</script>

</head>
<body>

	<div class=container>
		<div class=row>
			<div class="col-lg-11 mx-auto">
				<h4> &nbsp; Task History <span style=font-size:11px id=total>Total : ${taskList.size() }</span></h4>
				
				<div class="btn-group btn-group-toggle" data-toggle="buttons" style="float:right;">
					<label class="btn"><input name=1 type="radio" id="kinds" value=backup onchange=changeList(this)> Backups </label>
					<label class="btn" style=background-color:#669ee0><input name=1 type="radio" id="kinds" value=task onchange=changeList(this)> Tasks </label>
				</div>
				<br>
				<br>
				
				<table class="table table-hover" id=taskTable style="cursor:pointer; table-layout:fixed;word-break:break-all;">
					
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
							
							<tr id="tr${status.index }" class=innerTR >
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
				
				
				<table class="table table-hover" id=backupTable style="cursor:pointer; table-layout:fixed;word-break:break-all;display:none;">
					<colgroup>
						<col width=30%>
						<col width=15%>
						<col width=15%>
					</colgroup>
					
					<thead>
						<tr >
							<th> 이름 </th>
							<th> 백업타입 </th>
							<th> 크기 </th>
						</tr>
					</thead>
					
					<tbody>
						<c:if test="${empty backupList }">
							<tr>
								<td colspan=3 style=text-align:center;> 백업이 존재하지 않습니다.</td>
							</tr>
						</c:if>
						
						<c:if test="${not empty backupList }">
						
							<c:forEach items="${backupList.backups }" var="list" varStatus="status">
								<tr onclick='trClick("${status.index + taskList.size() }")'>
									<td>${list.date } </td>
									<td>${list.type } </td>
									<td>${list.size } </td>
								</tr>
								
								<tr id="tr${status.index + taskList.size() }" class=innerTR >
									
										<td colspan=3>
											<table class="table table-sm" style="cursor:auto;">
											
												<colgroup>
													<col width=20%>
													<col width=15%>
													<col width=15%>
													<col width=15%>
												</colgroup>
												<tr>
													<td> 버킷명</td>
													<td> 항목 수</td>
													<td> Mutation</td>
													<td> Tombstones</td>
													<td> Index</td>
													<td> Search</td>
													<td> Views</td>
													<td> Analytics</td>
												</tr>
												
												<c:forEach items="${list.buckets }" var="buckets" varStatus="status2">
													<tr>
														<td style=font-weight:bold;> [ ${buckets.name} ]</td>
														<td> ${buckets.items}</td>
														<td> ${buckets.mutations}</td>
														<td> ${buckets.tombstones}</td>
														<td> ${buckets.index_count}</td>
														<td> ${buckets.fts_count}</td>
														<td> ${buckets.views_count}</td>
														<td> ${buckets.analytics_count}</td>
													</tr>
													
													<tr>
														<td colspan=2> └ Scope 명</td>
														<td colspan=2> Mutation</td>
														<td colspan=2> Tombstones</td>
														<td colspan=2> Total Items</td>
													</tr>
														<c:forEach items='${buckets.scopes }' var="scopez" varStatus="status3">
															<tr id="scopeTR<%=trNum %>"></tr>
																	
															<script>
																var str = '${scopez}';
																str = str.substring(str.indexOf('=')+1);
																var json = JSON.parse(str);
																
																var html = '<td colspan=2>'+json.name+'</td>';
																	html += '<td colspan=2>'+json.mutations+' </td>';
																	html += '<td colspan=2>'+json.tombstones+' </td>';
																	html += '<td colspan=2>'+(json.tombstones+json.mutations)+' </td>';
																	
																$('#scopeTR<%=trNum%>').append(html);
																<% trNum++;%>
															</script>
																												
															
														</c:forEach>
												</c:forEach>
											</table>
										</td>
									</tr>
								</c:forEach>

						</c:if>
						
					</tbody>
					

				</table>				
		
			</div>
		</div>
	</div>

</body>
</html>