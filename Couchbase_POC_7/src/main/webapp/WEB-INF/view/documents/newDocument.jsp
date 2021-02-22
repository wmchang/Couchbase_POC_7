<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>

	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import>
	
<style>
	input[type="text"]{
		height: auto; /* 높이 초기화 */
		line-height: normal; /* line-height 초기화 */
		padding: .6em .02em; /* 여백 설정 */
		width:200px;
	}
	textarea {
	word-wrap: break-word;
	white-space: pre-wrap;
	white-space: -moz-pre-wrap;
	white-space: -pre-wrap;
	white-space: -o-pre-wrap;
	word-break: break-all;
	width:450px;
	height:400px;
}
</style>
</head>
<script>
	function addDocument(){
		
		let data = $("#documentForm").serializeArray();

		$.ajax({
			type:	"post",
			url:	"<%= request.getContextPath()%>/addDocument",
			data:	data,
			error:	function(xhr, status, error){
				alert('오류가 발생했습니다. 제대로된 JSON형식인지 확인해주십시오.');
			},
			success: function(data){
				alert(data);
				if(data.includes("생성"))
					window.close();
			}
		});
	}
	
	function closeEvent(){
	    opener.document.location.reload();
	}
</script>
<body onunload="closeEvent();">

	<div style=text-align:center;margin-top:15px;>
		<form id=documentForm name=documentForm>
			<input type="hidden" name=bucketName id=bucketName value='${bucketName }' />
			<input type="hidden" name=scopeName id=scopeName value='${scopeName }' />
			<input type="hidden" name=collectionName id=collectionName value='${collectionName }' />
			<p>Document ID: <input type="text" name=documentId id=documentId class="doc"/></p>
			<textarea id="documentText" name=documentText onkeydown="if(event.keyCode===9){var v=this.value,s=this.selectionStart,e=this.selectionEnd;this.value=v.substring(0, s)+'\t'+v.substring(e);this.selectionStart=this.selectionEnd=s+1;return false;}"></textarea>
		</form>
	</div>
	
	<br>
	<div style="text-align:right;margin-right:15px;">
		<button class="btn btn-primary" onclick="addDocument()">생성하기</button>
	</div>
	
</body>
</html>