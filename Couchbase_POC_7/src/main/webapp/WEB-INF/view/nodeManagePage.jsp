<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
</head>
<script>
	function rebalancing(){
		
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/rebalancing",
			error : function(xhr, status, error) {
				alert('에러입니다. 정상적인 값을 입력해주세요.');
			},
			success : function(data) {
				alert(data.result);
			}
		});
	}

	function addNodeNow(rebalancingCheck) {

		var check = addInputCheck();
		if (check == false) {
			alert('모든 항목을 입력하고 노드에서 사용할 서비스를 체크해주세요.');
			return;
		}
		
		var data = jQuery("#addNode").serializeArray();

		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/addNode",
			data : data,
			error : function(xhr, status, error) {
				alert('에러입니다. 정상적인 값을 입력해주세요.');
			},
			success : function(data) {
				alert(data.result);
				location.reload();
			}
		});
	}
	
	function addInputCheck() {
		let inputText = $("#addNode input");

		for (var i = 0; i < inputText.length; i++) {

			if (inputText[i].value == "" || inputText[i].value == null) {

				return false;
			}
		}
		if($('#addNode input[type=checkbox]:checked').length == 0)
			return false;
		
		return true;
	}

	function dropNodeNow(checkNode) {
		
		var check = dropInputCheck();
		if (check == false) {
			alert('모든 항목을 입력해주세요.');
			return;
		}
		
		if(checkNode == 1){
			document.dropNode.activeCheck.value = 'active';
		}
		else{
			document.dropNode.activeCheck.value = 'no';
		}

		var data = jQuery("#dropNode").serializeArray();

		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/dropNode",
			data : data,
			error : function(xhr, status, error) {
				alert('에러입니다. 정상적인 값을 입력해주세요.');
			},
			success : function(data) {
				alert(data.result);
				location.reload();
			}
		});
	}

	function dropInputCheck() {
		let inputText = $("#dropNode input");

		for (var i = 0; i < inputText.length; i++) {

			if (inputText[i].value == "" || inputText[i].value == null) {

				return false;
			}
		}
		return true;
	}
</script>
<body>
	<!-- header.jsp -->
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container-fluid>
		<div class=row>
	        <div class="col-xl-5 borderDiv mx-auto"><br>
	        	<h4> &nbsp; 노드 리스트 </h4>
	        	<div>
					<c:if test="${empty nodeList}">
						<h5> 노드 리스트를 확인하려면 <br>서버 연결 및 환경 설정을 해주십시오. </h5>
					</c:if>
					
					<c:if test="${not empty nodeList}">
						<button type="button" class="btn btn-success float-right" onclick="rebalancing();" style="margin-bottom:15px;">Rebalance</button>
						<table class="bucketTable table table-striped">
							<colgroup>
								<col width="5%" />
							    <col width="50%" />
							    <col width="1%" />
							    <col width="40%" />
							    <col width="1%" />
							</colgroup>
							<tr>
								<th>노드 이름</th>
								<th>서비스</th>
								<th>CPU</th>
								<th>RAM</th>
								<th>Swap</th>
							</tr>
						<c:forEach items="${nodeList }" var="list" >
		
							<tr>
								<td>${list.hostname }</td>
								<td style=width:100px;>${list.service }</td>
								<td>${list.cpu }%</td>
								<td>${list.ram_free} / ${list.ram_total }</td>
								<td>${list.swap }</td>
							</tr>
							
						</c:forEach>
						</table>
					</c:if>
				</div>
			
	        </div>
	        
	        <div class="col-xl-3 borderDiv mx-auto"><br>
	        	<h4> &nbsp; 노드 추가 </h4> <br>
	        	<form id="addNode" name="addNode" class=flexDiv>
					<div >
						# 호스트 이름 <input type="text" name="hostName" />
					</div>
					<div>
	     				 <label><input type="checkbox" name="service" value="kv"> Data</label>
	     				 <label><input type="checkbox" name="service" value="index"> Index</label>
	     				 <label><input type="checkbox" name="service" value="n1ql"> Query</label>
					</div>
					<div>
	     				 <label><input type="checkbox" name="service" value="fts"> Search</label>
	     				 <label><input type="checkbox" name="service" value="cbas"> Analytics</label>
	     				 <label><input type="checkbox" name="service" value="eventing"> Eventing</label>
					</div>
					<input type="hidden" name="rebalancing" value="no" />
					<button type="button" class="btn btn-primary float-right" onclick="addNodeNow();">노드 추가</button>
				</form>
	        </div>
	        
        	<div class="col-xl-3 borderDiv mx-auto"><br>
        		<h4> &nbsp; 노드 제거 </h4><br>
        		<form id="dropNode" name="dropNode" >
					<div>
						# 호스트 이름 <input type="text" name="dropHostName" />
					</div>
						<input type="hidden" name="activeCheck" value="no" />
					<button type="button" class="btn btn-warning" onclick="dropNodeNow(0);">비정상 노드 제거</button>
					<button type="button" class="btn btn-primary" onclick="dropNodeNow(1);">실행중인 노드 제거</button>
				</form>
        	
        	</div>
		</div>
	</div>

</body>
</html>