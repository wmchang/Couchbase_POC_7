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

	function setQuerySettings() {

		var check = inputCheck();
		if (check == false) {
			alert('모든 항목을 입력해주세요.');
			return;
		}

		var data = jQuery("#querySettingForm").serializeArray();

		$.ajax({
		    contentType : "application/x-www-form-urlencoded; charset=utf-8",
			type : "post",
			url : "<%= request.getContextPath()%>/setquerySettings",
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
		let inputText = $("#querySettingForm input");

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
	
	function urlRestrictChecking(){
		console.log(document.querySettingForm.curlAccessCheck.value);
		
		if(document.querySettingForm.curlAccessCheck.value=='false'){
			$("textarea#urlGroup").removeAttr("disabled");
		}
		else{
			$("textarea#urlGroup").attr("disabled", true);
		}
	}
	
</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
<form id="querySettingForm" name="querySettingForm" style=display:flex;>
	<div class="container" >
		<div class=row>
			<div class="mx-auto col-lg-5"><br>
				<h4> &nbsp; 쿼리 세팅</h4>
				
				<div>
					# Curl 액세스 허용:
					<input type="radio" name="curlAccessCheck" class=docRadio value="false" onchange=urlRestrictChecking() /> 제한
					<input type="radio" name="curlAccessCheck" class=docRadio value="true" checked onchange=urlRestrictChecking() /> 모두 허용
				</div><br>
				<div>
					- Curl 허용 URL <br />
					<textarea name=allowedURL id="urlGroup" cols="50" rows="5" disabled 
						placeholder='"https://www.company1.com"'>"https://www.company1.com"</textarea>
					<br /><br />
					- Curl 제한 URL <br />
					<textarea name="disallowedURL" id="urlGroup" cols="50" rows="5" disabled 
						placeholder='"https://www.company1.com", "https://www.company2.com"'>"https://www.company1.com"</textarea>
				</div>
			</div>
			
			<div class="mx-auto col-lg-5 flexDiv"><br>
				<div>
					# Query가 사용하는 임시 파일 경로:
					<input type="text" name="queryTmpSpaceDir" style=width:250px; />
				</div>
				<div>
					# Query가 사용하는 임시 파일 크기:
					<input type="text" name=queryTmpSpaceSize placeholder=5120 />
				</div>
				<div>
					# 병렬 처리 가능 최대 수:
					<input type="text" name=queryPipelineBatch placeholder=16 />
				</div>
				<div>
					# Fetch에서 버퍼링 가능한 최대 수: 
					<input type="text" name=queryPipelineCap placeholder=512 />
				</div>
				<div>
					# 인덱서와 쿼리서비스 사이의 최대 버퍼 채널 크기:
					<input type="text" name=queryScanCap  placeholder=512 />
				</div>
				<div>
					# 요청에 사용할 최대 시간:
					<input type="text" name=queryTimeout  placeholder=0 />
				</div>
				<div>
					# 캐시에 보관할 쿼리의 최대 수: 
					<input type="text" name=queryPreparedLimit placeholder=16384 />
				</div>
				<div>
					# 완료된 요청 카탈로그에 기록할 요청의 수: 
					<input type="text" name=queryCompletedLimit  placeholder=4000 />
				</div>
				<div>
					# 완료된 요청 카탈로그에 기록되는 기간(밀리초)
					<input type="text" name=queryCompletedThreshold  placeholder=1000 />
				</div>
				<div>
					# 로그 레벨 <select name="queryLogLevel" class=docSelect>
						<option value="error">error</option>
						<option value="warn">warn</option>
						<option value="info" selected>info</option>
						<option value="debug">debug</option>
						<option value="trace">trace</option>
						<option value="severe">severe</option>
						<option value="none">none</option>
					</select>
				</div>
				<div>
					# 병렬 집계를 위한 최대 인덱스 파티션의 수
					<input type="text" name=queryMaxParallelism  placeholder=1 />
				</div>
				<div>
					# N1QL Feature Controller (기술 지원용)
					<input type="text" name=queryN1QLFeatCtrl value=12 readonly />
				</div>
				<button type="button" class="btn btn-primary float-right" onclick="setQuerySettings();">저장</button>
			</div>
		</div>
	</div>
		
		
</form>

</body>
</html>