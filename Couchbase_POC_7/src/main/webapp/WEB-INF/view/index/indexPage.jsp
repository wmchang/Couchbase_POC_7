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
	

	function getIndexList(){
		
		setTimeout(function (){
			
			if(document.getElementById("bucket").value=='-Select Bucket-')
				return;
			
			let size = $('#bucketScope')[0].length;
			
			$('#scopeListDiv').html('');
			for(var i=0;i<size;i++){
				
				let scopes = $('#bucketScope')[0][i].value;
				$('#scopeListDiv').append('<input type=checkbox name=scopeList value='+scopes+' checked style=display:none;>');
			}
			
			$('#indexForm').submit();
			
		},100);
		
	}
	
	function deleteIndex(primary, name, keyspace){
		
		let data = "name="+name;
		data += "&keyspace="+keyspace;
		data += "&primary="+primary;
		
		waitToast('go');
		
 		$.ajax({
 			
			type : "post",
			url : "<%= request.getContextPath()%>/deleteIndex",
			data : data,
			error : function(xhr, status, error) {
				alert(error);
			},
			success : function(data) {
				waitToast('exit');
				
				if(data.length == 0){
					alert('삭제가 완료되었습니다.');
					location.reload();
				}
				else
					alert(data);
			}	
		}); 
		
	}
	
	function newIndex(){
		
		window.open('newIndexPage','팝업스','width=700, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');

	}

</script>
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
				<span style=font-size:13px;>&nbsp; Index Service Total Ram :  ${indexList[indexList.size()-1].memory_quota}</span><br>
				<span style=font-size:13px;>&nbsp; Index Service RAM 사용량 : ${indexList[indexList.size()-1].memory_percent}% </span>
				<br>
				
				<button class="btn btn-success" onclick="newIndex()" style=float:right;>Add Index</button>
				<button class="btn btn-light" onclick="location.href='<%= request.getContextPath()%>/index/indexPage'" style=float:right;margin-right:20px;>All Index</button>
				<br><Br>
				<div style=float:right; id=bucketScopeDiv>
					<form id=indexForm>
						<select name=bucket onchange="bucketChange(this);" id=bucket>
							<option value='-Select Bucket-'>-Select Bucket-</option>
						
							<c:forEach items="${bucketList }" var="list">
									<option value=${list } <c:if test="${list eq bucketName}">selected</c:if>>${list }</option>
							</c:forEach>
						</select>
						.
						<select name=bucketScope onchange="scopeChange(this); getIndexList();" id=bucketScope>
							
							<c:forEach items="${scopeList }" var="list">
									<option value=${list } <c:if test="${list eq scopeName}">selected</c:if> >${list }</option>
							</c:forEach>
						</select>
						
						<div id=scopeListDiv>
						</div>
					</form>
				</div>
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
					
						<tbody id=indexTbody>
					
							<c:forEach items="${indexList }" var="list" varStatus="status">
								
								<c:if test="${not empty list.name }">
									<tr onclick='trClick("${status.index }")'> 
										<td> ${list.name }</td>
										<td> ${list.items_count }</td>
										<td> ${list.data_size }</td>
										<td> ${list.keyspace }</td>
										<td> ${list.state }</td>
									</tr>
									
									
									
									<tr class=innerTR id="tr${status.index  }" >
										<td colspan=5 style=text-align:left;>정의: CREATE <c:if test="${list.is_primary eq true }" >PRIMARY </c:if>INDEX `${list.name }` ON `${list.keyspace }` 
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
											<br>
											<button class="btn btn-warning" onclick="deleteIndex('${list.is_primary }','${list.name}','${list.keyspace }');" style="float:right;">Drop Index</button>
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

<div id=toast></div>


</body>
</html>