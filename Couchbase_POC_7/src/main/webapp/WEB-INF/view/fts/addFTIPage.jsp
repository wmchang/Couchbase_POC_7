<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/index.css">

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
	
function addAnalyzer(){
		
		var document_window = window.open('addAnalyzerPage','팝업스','width=500, height=530, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no')
	}
	
	
</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import>
	
	
<form id="FTIForm" name="FTIForm" style=display:flex;>
	<div class="container">
		
		<div class="container-div" >
			<h1>Full Text Index 생성</h1><br><br>
			<div>
				<div >
					이름: <input type="text" name="name" />
				</div>
				<div>
					버킷: 
					<select name=sourceName>
						<c:forEach items="${bucketList }" var="list">
							<option value=${list.name }>${list.name }</option>
						</c:forEach>
					</select>
				</div>
				<div>
					<input type=hidden name=mode value=type_field>
					Json 타입 필드: 
					<input type="text" name=type_field value=type />
				</div>
				<div>
					문서 ID의 구분 문자: 
					<input type="text" name=docid_prefix_delim value=_ />
				</div>
				<div>
					문서 ID에 적용되는 정규식: 
					<input type="text" name=docid_regexp value="" />
				</div>
				<div>
					Type Mapping - 보류
				</div>
				<div>
					Analyzer name
					<button type="button" class="n1qlexcute" onclick="addAnalyzer()" style=float:right;>+ Add Analyzer</button>
				</div>
			</div>
		</div>
		
		
		
		<div class=container-div style="margin-top:30px;" id=checkEmailGroup>
			<div>
			
			
				<div align="right">
					<button type="button" class="n1qlexcute" onclick="setQuerySettings();">생성</button>
				</div>
			</div>
		</div>
	</div>
</form>

</body>
</html>