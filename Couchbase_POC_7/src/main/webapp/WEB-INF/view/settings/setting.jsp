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

	function setSetting() {

		var check = inputCheck($("#clusterSettings"));
		if (check == false) {
			alert('모든 항목을 입력해주세요.');
			return;
		}

		var data = jQuery("#clusterSettings").serializeArray();

		$.ajax({
		    contentType : "application/x-www-form-urlencoded; charset=utf-8",
			type : "post",
			url : "<%= request.getContextPath()%>/setSettings",
			data : data,
			error : function(xhr, status, error) {
				alert(data);
			},
			success : function(data) {
				alert(data);
			}
		});
	}
	
	function failoverDisabled(chk){
		
		if(!chk.checked){
			$('.autoFailoverDataErrorSecondTime').attr("disabled", true);
		}else{
			$('.autoFailoverDataErrorSecondTime').removeAttr("disabled");
		}
		
		
	};
	
	function threadCheck(check){
		if(check.value=='fixedValue'){
			if(check.name=='readThread'){
				$("input#readThreadNumber").removeAttr("disabled");
			}
			else{
				$("input#writeThreadNumber").removeAttr("disabled");
			}
		}else{
			
			if(check.name=='readThread'){
				$("input#readThreadNumber").attr("disabled", true);
			}
			else{
				$("input#writeThreadNumber").attr("disabled", true);
			}
		}
	}

</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
<form id=clusterSettings name="clusterSettings" style=display:flex;>
	
	<div class=container-fluid>
		<div class=row>
			<div class="mx-auto col-lg-3 flexDiv borderDiv"><br>
				<h4> &nbsp; 클러스터 세팅 </h4><br>
				<div>
					# 클러스터 이름 <input type="text" name="clusterName" />
				</div>
				<h5>&nbsp;# 메모리 할당량 (단위: MB)</h5>
				<div>
					# Data Service <input type="text" name="dataServiceQuota" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value=256 />
				</div>

				<div>
					# Index Service <input type="text" name="indexServiceQuota" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value=256 />
				</div>
				<div>
					# Search Service <input type="text" name="searchServiceQuota" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"  value=256 />
				</div>
				<div>
					# Analytics Service <input type="text" name="analyticsServiceQuota" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value=1024  />
				</div>
				<div>
					# Eventing Service <input type="text" name="eventingServiceQuota" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" value=256  />
				</div>

				<div style=display:block;>
					# 최신버전 업데이트 알림
					<input type="checkbox" name="noticeUpdate" value="true" checked>
					<input type='hidden' value='false' name='noticeUpdate'>
				</div>
				
			</div>
			<div class="mx-auto col-lg-4 borderDiv"><br>
				<h4>&nbsp; 노드 가용성</h4><br>

				<div>
					<input type="checkbox" name="autoFailoverCheck" id="failoverGroup" value="true" checked	onchange="checkboxDisableChecking(this)">
					<input type='hidden' name='autoFailoverCheck' value='false'>
					# <input type="text" name=failoverSecondTime id="failoverGroup" style="width: 50px; height:25px;" class=doc value=120 />초 동안
					<input type="text" name="failoverEvent" id="failoverGroup" style="width: 50px; height:25px;" class=doc value=1  /> 개의 이벤트가 실행되지 못하면 오토 페일오버
				</div><br>
				<div>
					<input type="checkbox" name="autoFailoverDataError" value="true" id="failoverGroup" onchange="failoverDisabled(this)">
					<input type='hidden' name='autoFailoverDataError' value='false'>
					# 지속적으로 <input type="text" name="autoFailoverDataErrorSecondTime" id="failoverGroup" class=autoFailoverDataErrorSecondTime style="width: 50px; height:25px;" class=doc value=120 disabled />
					초 동안 디스크에 데이터 읽고/쓰기 오류가 발생하면 오토 페일 오버
				</div><br>
				<div>
					<input type="checkbox" name="autoFailoverServerGroup" value="true" id="failoverGroup">
					<input type='hidden' name="autoFailoverServerGroup" value='false'>
					 # 서버 그룹의 오토 페일오버 가능 여부
				</div><br>
				<div>
					<input type="checkbox" name="autoFailoverStopRebalance" value="true" checked id="failoverGroup">
					<input type='hidden' name="autoFailoverStopRebalance" value='false'>
					# 오토 페일오버 수행 시 리밸런싱 중단 가능 여부
				</div><br>
				<div>
					<input type='hidden' name="autoReprovisioning" value="false">
					<input type="checkbox" name="autoReprovisioning" value="true" checked onchange=checkboxDisableChecking(this) id=reprovisioningGroup>
					# Ephemeral 버킷을 포함하는 노드를 사용할 수 없게 되면
					<input type="text" name="autoReprovisioningNode" style="width: 50px; height:25px;" id=reprovisioningGroup class=doc value=1 />
					노드의 복제본을 활성화 상태로 변경
				</div>
				
				<div>
					<input type="checkbox" name="retryRebalance_Enable" value="true" id="rebalanceGroup" onchange="checkboxDisableChecking(this)">
					<input type='hidden' name='retryRebalance_Enable' value='false'>
					# Rebalance 실패 시 <input type="text" name="retryRebalance_afterTimePeriod" id="rebalanceGroup" style="width: 50px; height:25px;" disabled value=300 />
					초 뒤에 최대 <input type="text" name="retryRebalance_maxAttempts" id="rebalanceGroup" class=autoFailoverDataErrorSecondTime style="width: 50px; height:25px;" disabled value=1 />번 재시도
				</div><br>
				
			</div>
			<div class="mx-auto col-lg-3 borderDiv"><br>
				<h4> &nbsp; Setting etc</h4><br>

				<div>
					<h5>
						읽기 쓰레드 수 
						<input type="text" name="readThreadNumber" id=readThreadNumber style="width: 50px; float: right;" class=doc disabled />
					</h5>
					<div style="display:inline-block;">
						<input type="radio" name="readThread" value="fixedValue" onchange="threadCheck(this);" /> 
						<label>Fixed value</label>
						
						<input type="radio" name="readThread" value="diskIoOptimized" onchange="threadCheck(this);" />
						<label>DiskI/O optimized</label>
						
						<input type="radio" name="readThread" value="default" checked onchange="threadCheck(this);" />
						<label>Default</label>
					</div>
				</div>

				<div>
					<h5>
						쓰기 쓰레드 수 <input type="text" name="writeThreadNumber" id="writeThreadNumber" style="width: 50px; float: right;" class=doc disabled />
					</h5>
					<div style="display:inline-block;">
						<input type="radio" name="writeThread" value="fixedValue" onchange="threadCheck(this);" />
						<label>Fixed value</label>
						
						<input type="radio" name="writeThread" value="diskIoOptimized" onchange="threadCheck(this);" />
						<label>Disk I/O optimized</label>
						
						<input type="radio" name="writeThread" value="default" checked onchange="threadCheck(this);" />
						<label>Default</label>
					</div>
				</div>

				<div>
					<h5>인덱스 저장 모드</h5>
						<input type="radio" name="IndexStorageMode" value="Memory-Optimized" />
						<label>Memory-Optimized</label>
						<br>
						<input type="radio" name="IndexStorageMode" value="StandardGlobalSecondary" checked />
						<label>Standard Global Secondary</label>
				</div>
				<div>
					# 인덱서 쓰레드 개수 <input type="text"name="IndexerThreadNumber" style="width: 50px; float:right;" class=doc value=0 />
				</div><br>
				<div>
					# 인덱서 로그 레벨 <select name="logLevel" class=docSelect style=float:right;>
						<option value="silent">Silent</option>
						<option value="fatal">Fatal</option>
						<option value="error">error</option>
						<option value="warn">warn</option>
						<option value="info" selected>info</option>
						<option value="verbose">verbose</option>
						<option value="timing">timing</option>
						<option value="debug">debug</option>
						<option value="trace">trace</option>
					</select>
				</div><br>
				<div>
					# XDCR 최대 프로세스 수
					<input type="text"name="XDCRMaximumProcesses" style="float:right;" class=doc value=4 />
				</div><br>
				<button type="button" class="btn btn-primary float-right" onclick="setSetting();">실행</button>
			</div>
		</div>
	</div>
	</form>
</body>
</html>