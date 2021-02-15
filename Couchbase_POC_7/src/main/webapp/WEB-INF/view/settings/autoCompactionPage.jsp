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

	function setCompaction() {

		var check = inputCheck($("#autoCompactionForm"));
		if (check == false) {
			alert('모든 항목을 입력해주세요.');
			return;
		}

		var data = jQuery("#autoCompactionForm").serializeArray();

		$.ajax({
		    contentType : "application/x-www-form-urlencoded; charset=utf-8",
			type : "post",
			url : "<%= request.getContextPath()%>/setCompactions",
			data : data,
			error : function(xhr, status, error) {
				alert(data);
			},
			success : function(data) {
				alert(data);
			}
		});
	}

	function compactionTimeCheck(){
		
		if(document.getElementById("timeIntervalCheck").checked==false)
			$("input#timeGroup").attr("disabled", true);
		else
			$("input#timeGroup").removeAttr("disabled");
	}
	
	function compactionChecking(chk){
		
		if(chk.checked==false){
			if(chk.name=='fragmentationCheckDatabasePer')
				$("input#fragmentationPercentDatabase").attr("disabled", true);
			else if(chk.name=='fragmentationCheckDatabaseMB'){
				$("input#fragmentationMBDatabase").attr("disabled", true);
			}
			else if(chk.name=='fragmentationCheckViewPer'){
				$("input#fragmentationPercentView").attr("disabled", true);
			}
			else if(chk.name=='fragmentationCheckViewMB'){
				$("input#fragmentationMBView").attr("disabled", true);
			}
		}else {
			if(chk.name=='fragmentationCheckDatabasePer')
				$("input#fragmentationPercentDatabase").removeAttr("disabled");
			else if(chk.name=='fragmentationCheckDatabaseMB'){
				$("input#fragmentationMBDatabase").removeAttr("disabled");
			}
			else if(chk.name=='fragmentationCheckViewPer'){
				$("input#fragmentationPercentView").removeAttr("disabled");			}
			else if(chk.name=='fragmentationCheckViewMB'){
				$("input#fragmentationMBView").removeAttr("disabled");
			}
		}
	}


</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	
<form id="autoCompactionForm" name="autoCompactionForm" style=display:flex;>
	<div class="container">
	
		<div class=row>
			<div class="mx-auto col-lg-5"><br>
				<h4> &nbsp; 자동 압축 </h4><br>
					<h5>- 데이터베이스 조각화 </h5>
					<div>
						<input type="checkbox" name="fragmentationCheckDatabasePer" value="true" style=margin-top:10px; checked onchange=compactionChecking(this); />
						<input type="text" name="fragmentationPercentDatabase" id=fragmentationPercentDatabase class=doc style=width:100px; value=30 />%
					</div><br>
					<div>
						<input type="checkbox" name="fragmentationCheckDatabaseMB" value="true" style=margin-top:10px; onchange=compactionChecking(this); />
						<input type="text" name="fragmentationMBDatabase" id=fragmentationMBDatabase class=doc style=width:100px; disabled  />MB
					</div>
					
					<h5>- 뷰 조각화</h5>
					<div>
						<input type="checkbox" name="fragmentationCheckViewPer" value="true" style=margin-top:10px; checked  onchange=compactionChecking(this); />
						<input type="text" name="fragmentationPercentView" id=fragmentationPercentView class=doc style=width:100px; value=30 />%
					</div><br>
					<div>
						<input type="checkbox" name="fragmentationCheckViewMB" value="true" style=margin-top:10px; onchange=compactionChecking(this); />
						<input type="text" name="fragmentationMBView" id=fragmentationMBView  class=doc style=width:100px; disabled />MB
					</div><br>
				
					<h5> - 압축 실행 간격 </h5>
					<div>
						<input type="checkbox" name="timeIntervalCheck" id=timeIntervalCheck value="true" style=margin-top:10px; onchange=compactionTimeCheck() />
						<input type='hidden' name="timeIntervalCheck" value='false'>
						압축 실행 간격 설정
					</div>
					<div>
						# Start Time
						<input type="text" name="compactionFromHour" class=doc style=width:100px; placeholder=HH id=timeGroup disabled />:
						<input type="text" name="compactionFromMinute" class=doc style=width:100px; placeholder=MM  id=timeGroup disabled />
					</div>
					<div>
						# End Time
						<input type="text" name="compactionToHour" class=doc style=width:100px; placeholder=HH id=timeGroup disabled />:
						<input type="text" name="compactionToMinute" class=doc style=width:100px; placeholder=MM id=timeGroup disabled />
					</div>
					<div>
						<input type="checkbox" name="abortCompaction" id=timeGroup value="true" disabled />
						<input type='hidden' name="abortCompaction" value='false'>
						지정된 시간 초과 시 압축 중단
					</div>
					<div>
						<input type="checkbox" name="compactParallel" value="true"  />
						<input type='hidden' name="compactParallel" value='false'>
						버킷과 뷰, 인덱스를 병렬로 압축
					</div><br>
					
					<h5>- 메타데이터의 삭제 빈도  [0.04(1시간)~60(60일)]</h5>
					<input type="text" name="purgeInterval" class=doc style=width:100px; value=3 />days
					
					<br>
					<button type="button" class="btn btn-primary float-right" onclick="setCompaction();">실행</button>
			</div>
			
		</div>
		
		
	</div>
</form>

</body>
</html>