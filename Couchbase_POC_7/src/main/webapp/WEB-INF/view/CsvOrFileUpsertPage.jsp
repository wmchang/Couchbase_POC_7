<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
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

</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container>
		<div class=row>
			<div class="mx-auto col-sm-5"><br>
	        <h4> &nbsp; CSV 혹은 JSON 파일 업로드 </h4><br>
	        	<form id="fileUpload" name="fileUpload" enctype="multipart/form-data">
					
		        	<div>
						# 확장자 선택<br>
						<input type="radio" name="fileExtension" value="csv" checked />
						<label>CSV</label> &nbsp;
						
						<input type="radio" name="fileExtension" value="json"  /> 
						<label>Json</label> &nbsp;
						
						<input type="radio" name="fileExtension" value="jsonList"  /> 
						<label>Json List</label> &nbsp;
					</div>
					<div>
						# 문서 아이디
						(<input type="checkbox" name="columnOfExcel" value="true" checked ><span style=font-size:10px> 파일내 컬럼으로 지정 </span>)
						<br>
						<input type="text" id="docId" name="docId" required="required" />  
					</div>
					<div>
						# cbimport 경로(Couchbase\Server\bin)<br>
						<input type="text" name="cbPath"  required="required" />
					</div><br>
					<div>
						파일 경로 : <input id="fileName" name="fileName" type=file
									accept=".csv, .json" required="required" >
					</div>
				</form>
				<button type="submit" class="btn btn-primary float-right" onclick="uploadFile();">실행</button>
	        </div>
        
        	<div class="mx-auto col-sm-5"><br>
        		<h4> &nbsp; 작업 결과</h4><br>
        		<textarea id="uploadResult" name="uploadResult" readonly
					placeholder="작업을 실행해주세요." style="width:500px; height:500px;">
				</textarea>
        	</div>
		</div>
	</div>

</body>
</html>