<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

<style>
	input[type="text"], select{
		height: auto; /* 높이 초기화 */
		line-height: normal; /* line-height 초기화 */
		padding: .6em .02em; /* 여백 설정 */
		width:200px;
	}
	.n1qlexcute {
	border: none;
	color: white;
	padding: 10px 15px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
	border-radius: 12px;
	background-color: #4287d6;
	transition-duration: 0.4s;
}

.n1qlexcute:hover {
	background-color: #79aae4;
}
input, label {
    display:block;
}
textarea, label {
    display:block;
}
div{
	margin:8px;
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
				window.close();
			}
		});
	}
	
	function closeEvent(){
	    opener.document.location.reload();
	}
</script>
<body onunload="closeEvent();">

	<div>
		<label for=sourceBucket>Source Bucket</label><input type="text" name=sourceBucket id=sourceBucket />
	</div>
	<div>
		<label for=metaBucket>Meta Bucket</label><input type="text" name=metaBucket id=metaBucket />
	</div>
	<div>
		<label for=functionName>Function Name</label><input type="text" name=functionName id=functionName />
	</div>
	<div>
		<label for=description>Description</label><textarea name="description" id="description" rows="3" cols="50" ></textarea>
	</div>
	<div>
		<label for=systemLogLevel>System Log Level</label>
		<select name=systemLogLevel>
			<option value=info>Info</option>
			<option value=error>Error</option>
			<option value=warning>Warning</option>
			<option value=debug>Debug</option>
			<option value=trace>Trace</option>
		</select>
	</div>
	<div>
		<label for=n1qlConsistency>N1QL Consistency</label>
		<select name=n1qlConsistency>
			<option value=none>None</option>
			<option value=request>Request</option>
		</select>
	</div>
	<div>
		<label for=workers>Workers</label><input type="text" name=workers id=workers />
	</div>
	<div>
		<label for=scriptTimeout>ScriptTimeout</label><input type="text" name=scriptTimeout id=scriptTimeout />
	</div>
	
	<div align="right">
		<button type="button" class="n1qlexcute" onclick="addFunction();">생성</button>
	</div>
</body>
</html>