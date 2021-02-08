<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

</head>
<script>

	function setEmailSettings() {

		var check = inputCheck();
		if (check == false) {
			alert('모든 항목을 입력해주세요.');
			return;
		}

		var data = jQuery("#emailAlertsForm").serializeArray();

		$.ajax({
		    contentType : "application/x-www-form-urlencoded; charset=utf-8",
			type : "post",
			url : "<%= request.getContextPath()%>/setEmailAlerts",
			data : data,
			error : function(xhr, status, error) {
				alert(data);
			},
			success : function(data) {
				alert(data);
			}
		});
	}

	function inputCheck() {
		let inputText = $("#autoCompactionForm input");

		for (var i = 0; i < inputText.length; i++) {

			if (inputText[i].value == "" || inputText[i].value == null) {
				if(inputText[i].disabled){
					continue;
				}
				return false;
			}
		}
		return true;
	}
	
	function emailAlertChecking(){
		if(document.getElementById("emailAlertCheck").checked==false){
			$("input#emailGroup").attr("disabled", true);
			$("textarea#emailGroup").attr("disabled", true);
		}
		else{
			$("input#emailGroup").removeAttr("disabled");
			$("textarea#emailGroup").removeAttr("disabled");
		}
	}
	
</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
<form id="emailAlertsForm" name="emailAlertsForm" style=display:flex;>
	<div class="container" >
		<div class=row>
			<div class="mx-auto col-lg-5"><br>
				<h4> &nbsp; 이메일 알림 서비스</h4><br>
				<div>
					<input type="checkbox" name="emailAlertCheck" id=emailAlertCheck value="true" style=margin-top:10px; onchange=emailAlertChecking() />
					이메일 알림 서비스 사용
				</div><br>
				<div>
					Email Server Host
					<input type="text" name="emailServerHost" id=emailGroup style=width:100px; disabled placeholder=localhost />
				</div>
				<div>
					Port
					<input type="text" name="emailServerPort" id=emailGroup style=width:100px; disabled placeholder=25 />
				</div>
				<div>
					Username
					<input type="text" name="emailServerUsername" id=emailGroup style=width:100px; disabled />
				</div>
				<div>
					Password 
					<input type="text" name="emailServerPassword" id=emailGroup style=width:100px; disabled />
				</div>
				<div>
					<input type="checkbox" name="emailTLS" id=emailGroup value="true" style=margin-top:10px; disabled />
					TLS 사용
				</div>
				<div>
					보내는 사람 Email
					<input type="text" name="sender" id=emailGroup style=width:170px; disabled />
				</div>
				<div>
					받을 사람 Email [여러 명일 시 엔터로 구분]
					<textarea name="recipients" id="emailGroup" cols="50" rows="5" disabled ></textarea>
				</div>
				<button type="button" class="btn btn-primary float-right align-bottom" onclick="setEmailSettings();">저장</button>
			</div>
			
			<div class="mx-auto col-lg-5" id=checkEmailGroup><br>
				<div>
					<input type="checkbox" name="alerts" id=emailGroup value="auto_failover_node" style=margin-top:10px; disabled />
					노드에 오토 페일오버가 발생했을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="auto_failover_maximum_reached" style=margin-top:10px; disabled />
					오토 페일오버가 사용가능한 최대 예비 노드수에 도달하면 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="auto_failover_other_nodes_down" style=margin-top:10px; disabled />
					다운된 노드가 존재하여 오토 페일오버를 하지 못하는 상황일 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="auto_failover_cluster_too_small" style=margin-top:10px; disabled />
					노드가 3개 미만이어서 오토 페일오버를 하지 못하는 상황일 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="auto_failover_disabled" style=margin-top:10px; disabled />
					노드에 할당된 하나 이상의 서비스가 비활성화되어있어 오토 페일오버를 하지 못하는 상황일 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="ip" style=margin-top:10px; disabled />
					노드의 IP 주소가 갑자기 변경되었을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="disk" style=margin-top:10px; disabled />
					디스크의 공간이 90%이상 찼을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="overhead" style=margin-top:10px; disabled />
					메타 데이터의 정보를 저장하는데 사용가능한 램 용량의 50%를 초과했을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="ep_oom_errors" style=margin-top:10px; disabled />
					노드의 사용가능한 모든 RAM이 메타데이터를 저장하는데 사용되고 있어 데이터 저장이 불가능할 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="ep_item_commit_failed" style=margin-top:10px; disabled />
					디스크 또는 장치에 버킷의 데이터를 저장 실패했을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="audit_dropped_events" style=margin-top:10px; disabled />
					감사 로그 이벤트 쓰기에 실패했을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="indexer_ram_max_usage" style=margin-top:10px; disabled />
					인덱서 램의 임계값이 경고치에 가까워지고있을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="ep_clock_cas_drift_threshold_exceeded" style=margin-top:10px; disabled />
					원격 Mutation 타임스태프가 드리프트 임계값을 초과했을 때 알림<br>
					
					<input type="checkbox" name="alerts" id=emailGroup value="communication_issue" style=margin-top:10px; disabled />
					클러스터 내의 노드에 통신 문제가 있을 때 알림<br>
					
				</div>
			</div>
		</div>
	</div>
</form>

</body>
</html>