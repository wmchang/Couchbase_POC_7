<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
</head>
<script>

	function createNewBucket() {
		
		var check = inputCheck($("#createBucket"));
		if(check == false){
			alert('모든 항목을 입력해주세요.');
			return;
		}
		
		var data = $("#createBucket").serializeArray();
	
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/createBucket",
			data : data,
			error : function(xhr, status, error) {
				alert(error);
			},
			success : function(data) {
				alert(data);
				if(data.includes("생성"))
					location.reload();
			}
		});
	}
	
	function getScopeCollection(chk){
		window.open('scopePage?bucketName='+chk.id,'팝업','width=550, height=570, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no')
	}
	
	function dropBucketNow(chk) {
		
		
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/dropBucket?bucketName="+chk.id,
			error : function(xhr, status, error) {
				alert(error);
			},
			success : function(data) {
				alert(data);
				
				if(data.includes("삭제"))
					location.reload();
			}
		}); 
	}
	
</script>
<body>
		<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	<div class=container-fluid>
		<div class=row>
	        <div class="col-xl-8 borderDiv mx-auto"><br>
	        	<h4> &nbsp; 버킷 리스트</h4><br>
				<div>
					<c:if test="${empty bucketList}">
						<h5> 버킷 리스트를 확인하려면 서버 연결 및 환경 설정을 해주십시오.</h5>
					</c:if>
				
					<c:if test="${not empty bucketList}">
						<table class="bucketTable table table-striped">
							<colgroup>
								<col width="15%" />
							    <col width="5%" />
							    <col width="14%" />
							    <col width="30%" />
							    <col width="10%" />
							    <col width="12%" />
							    <col width="12%" />
							</colgroup>
							<tr>
								<th>버킷이름</th>
								<th>버킷타입</th>
								<th>문서 수</th>
								<th>메모리 사용량</th>
								<th>디스크 사용량</th>
								<th>Scope</th>
								<th>삭제</th>
							</tr>
					
					
						<c:forEach items="${bucketList }" var="list" >
		
							<tr>
								<td>${list.name }</td>
								<td>${list.bucketType }</td>
								<td>${list.itemCount }</td>
								<td>${list.quotaPercentUsed }% (${list.memUsed }MB / ${list.ram }MB)</td>
								<td>${list.diskUsed }MB </td>
								<td><a href="#" id=${list.name } onclick="getScopeCollection(this);">Scope</a> </td>
								<td><button type="button" class="btn btn-warning float-right" id=${list.name } onclick="dropBucketNow(this);">제거</button> </td>
								
							</tr>
							
						</c:forEach>
						</table>
					</c:if>
	       		</div>
	        </div>
	        <div class="col-xl-3 borderDiv mx-auto"><br>
	        <form id="createBucket" name="createBucket" class="flexDiv" >
	        	<h4> &nbsp; 버킷 생성</h4><br>
				
					<div>
						# 버킷의 이름 <input type="text" id="newBucketName" name="newBucketName">
					</div>
		
					<div>
						# 버킷 타입 <select name="newBucketType">
							<option selected value="COUCHBASE">Couchbase</option>
							<option value="EPHEMERAL">Ephemeral</option>
							<option value="MEMCACHED">Memcached</option>
						</select>
					</div>
		
					<div>
						# 메모리 할당(MB)<input type="text" name="bucketMemory"
							onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
					</div>
		
					<div>
						# 복제본 수 <select name="newBucketReplicas">
							<option selected value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</div>
					<div>
						# Index 복제 여부
						<div>
							<input type="radio" name="indexReplicaEnable" value="true" />
							<label for="True">True</label>
							
							<input type="radio" name="indexReplicaEnable" value="false" checked /> 
							<label for="False">False</label>
						</div>
					</div>
		
					<div>
						# Flush 기능 활성화 여부
						<div>
							<input type="radio" name="flushEnable" value="true" />	
							<label for="True">True</label>
							
							<input type="radio" name="flushEnable" value="false" checked /> 
							<label for="False">False</label>
						</div>
					</div>
		
		
					<button type="button" class="btn btn-primary float-right" onclick="createNewBucket();">실행</button>
				</form>
	        </div>
	    </div>
    </div>
	
	

</body>
</html>