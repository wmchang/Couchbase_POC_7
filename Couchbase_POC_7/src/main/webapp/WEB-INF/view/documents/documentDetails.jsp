<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>

<meta charset="EUC-KR">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/index.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"><!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="<%= request.getContextPath()%>/static/js/head_function.js"></script>


<style>
textarea {
	word-wrap: break-word;
	white-space: pre-wrap;
	white-space: -moz-pre-wrap;
	white-space: -pre-wrap;
	white-space: -o-pre-wrap;
	word-break: break-all;
	width:500px;
	height:500px;
}
</style>
</head>
<script>
	function upsertDocument(){
		
		let data = $("#documentForm").serializeArray();
		
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/documentUpsert",
			data : data,
			error : function(xhr, status, error) {
				alert('오류가 발생했습니다. 제대로된 JSON 형식인지 확인해주십시오.');
			},
			success : function(data) {
				alert(data);
				_checkClose(data,"변경");
			}
		});
	}
	
	function closeEvent(){
	    opener.document.location.reload();
	}
	
	function deleteDocument(){
		
		if(confirm('삭제하시겠습니까?') == false)
			return;
		let data = $("#documentForm").serializeArray();
		
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/dropDocument",
			data : data,
			error : function(xhr, status, error) {
				alert('오류가 발생했습니다.');
			},
			success : function(data) {
				alert(data);
				window.close();
			}
		});
	}

</script>

<body onunload="closeEvent();">
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

	<div style=text-align:center;margin-top:15px;>
		<form id=documentForm name=documentForm>
			<input type="hidden" name=bucketName id=bucketName value=${bucketName } />
			<input type="hidden" name=scopeName id=scopeName value='${scopeName }' />
			<input type="hidden" name=collectionName id=collectionName value='${collectionName }' />
			<input type="hidden" name=documentId id=documentId value=${documentId } />
			<textarea id="documentText" name=documentText onkeydown="if(event.keyCode===9){var v=this.value,s=this.selectionStart,e=this.selectionEnd;this.value=v.substring(0, s)+'\t'+v.substring(e);this.selectionStart=this.selectionEnd=s+1;return false;}" ><c:out value="${documentDetails}" /></textarea>
		</form>
	</div>
	
	<button class="btn btn-primary float-right" onclick="upsertDocument()" style=margin-right:15px;>저장</button>
	<button class="btn btn-primary float-right" onclick="deleteDocument()" style=margin-right:10px;>삭제</button>
</body>
</html>