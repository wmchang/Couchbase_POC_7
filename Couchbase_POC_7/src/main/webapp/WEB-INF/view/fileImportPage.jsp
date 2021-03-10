<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
</head>
<script>
function uploadFile() {
	
	var check = inputCheck($('#fileUpload'));
	if(check == false){
		alert('모든 항목을 입력해주세요.');
		return;
	}

	var data = new FormData(document.getElementById('fileUpload'));
	$.ajax({
		type : "post",
		url : "<%= request.getContextPath()%>/fileUpload",
		enctype : "multipart/form-data",
		data : data,
		processData : false,
		contentType : false,
		error : function(xhr, status, error) {
			$('#uploadResult').val("업로드 처리 오류");
		},

		success : function(data) {
			
			
			alert(data);

		}

	});
}

function selectBatch(chk){
	
	if(chk.value == 'batch'){
		$("input:checkbox[id='keyIsExcel']").prop("checked", false);
		$('#keyIsExcel').attr('disabled', 'true');
	}
	else{
		$('#keyIsExcel').removeAttr('disabled');
	}
}

</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container>
		<div class=row>
			<div class="mx-auto col-lg-5"><br>
	        <h4> &nbsp; 파일 업로드 (CSV or JSON)<span style=font-size:12px;>(Encoding: UTF-8)</span> </h4><br>
	        
	        	<c:if test="${empty bucketName}">
						<h5> 서버를 연결해주세요.</h5>
				</c:if>
					
				<c:if test="${not empty bucketName}">
					
	        	<form id="fileUpload" name="fileUpload" enctype="multipart/form-data" style=text-align:center; action="/fileImportPage">
	        	
        			<div>
						<label ># Bucket</label><br>
						<select name=bucketName onchange=bucketChange(this) id=bucket>
								<option value='-Select Bucket-'>-Select Bucket-</option>
							<c:forEach items="${bucketList }" var="list">
								<option value=${list } <c:if test="${list eq bucketName}">selected</c:if>>${list }</option>
							</c:forEach>
						</select>
					</div>
					<div>
					<label ># Scope</label><br>
					<select name=scopeName onchange=scopeChange(this) id=bucketScope>
						<c:forEach items="${scopeList }" var="list">
							<option value=${list } <c:if test="${list eq scopeName}">selected</c:if> >${list }</option>
						</c:forEach>
					</select>
					</div>
					
					<div>
					<label ># Collection</label><br>
					<select name=collectionName id=bucketScopeCollection>
						<c:forEach items="${collectionList }" var="list">
							<option value=${list } <c:if test="${list eq collectionName}">selected</c:if> >${list }</option>
						</c:forEach>
					</select>
					</div>
					<br>
					<div>
						# 문서 아이디
						(<span style=font-size:10px> 파일내 컬럼으로 지정 </span><input type="checkbox" name="keyIsExcel" id=keyIsExcel value="true" >)
						<br>
						<input type="text" id="docId" name="docId" required="required" value="<%=(request.getParameter("docId")==null) ? "" : request.getParameter("docId") %>" />  
					</div>
		        	<div>
						# 형태 선택<br>
						<input type="radio" name="batchType" value="split" checked  onchange="selectBatch(this)" />
						<label>컬럼별로 개별 문서로 삽입</label> &nbsp;
						
						<input type="radio" name="batchType" value="batch" onchange="selectBatch(this)"  /> 
						<label>모두 한 문서에 삽입</label> &nbsp;
					</div>
					<div>
						파일 경로 : <input id="fileName" name="fileName" type=file
									accept=".csv, .json" required="required" >
					</div>
					<br>
					<button type="button" class="btn btn-primary" onclick="uploadFile();">실행</button>
				</form>
				</c:if>
	        </div>
		</div>
	</div>

</body>
</html>