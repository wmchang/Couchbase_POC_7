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
	
	var check = inputCheck();
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
			var obj = eval(data);
			if (obj.suc == "OK") {
				if (obj.mapFlag == "1") {
					$('#uploadResult').val(obj.idThreadCheck);
				} else if (obj.mapFlag == "2") {
					$('#uploadResult').val(obj.ExtentionsCheck);
				} else if (obj.mapFlag == "3") {
					$('#uploadResult').val(obj.csvInsert);
				} else if (obj.mapFlag == "4") {
					$('#uploadResult').val(obj.jsonInsert);
				}
			} else {
				$('#uploadResult').val(obj.fileCheck);
			}

		}

	});
}

function inputCheck(){
	let inputText = $("#fileUpload input[type=text]");
	
	for(var i=0;i<inputText.length; i++){
		
		if(inputText[i].value == "" || inputText[i].value == null){
			
			return false;
		}
	}		
	return true;
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
						문서 아이디 :
						<input type="text" id="docId" name="docId" required="required" /> 
					</div>
					<div>
						쓰레드 개수 :
						<input type="text" name="threadCount"  required="required"
								onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
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