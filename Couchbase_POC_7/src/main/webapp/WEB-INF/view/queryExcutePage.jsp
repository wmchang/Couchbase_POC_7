<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
<style>
	textarea {
	width: 90%;
	height: 180px;
	background-color: #ebecf0;
}
</style>
</head>
<script>
	function queryExcute() {
		
		var check = inputCheck($("#queryForm"));
		if(check == false){
			alert('모든 항목을 입력해주세요.');
			return;
		}
		
		var data = $("#queryForm").serializeArray();
	
		$.ajax({
				type : "post",
				url : "<%= request.getContextPath()%>/getQueryResult",
				data : data,
				error : function(xhr, status, error) {
					$('#queryResult').val("에러가 발생하였습니다. 문서의 ID가 중복 혹은 존재하지 않습니다.");
				},
				success : function(data) {
					
					if(typeof(data) == 'string'){
						$('#queryResult').val(data);
					}else{
						let obj = eval(data);
						$('#queryResult').val(obj.allRows);
						let ugly = document.getElementById('queryResult').value;
						obj = JSON.parse(ugly);
						let pretty = JSON.stringify(obj, null, 4);
						document.getElementById('queryResult').value = pretty;
					}
				}
			});
	}
	
	function reset(){
		document.getElementById('documentId').value="";
		document.getElementById('sdkWriInput').value="";
	}
	
	function resize(obj) {
		  obj.style.height = "1px";
		  obj.style.height = (12+obj.scrollHeight)+"px";
		}
</script>
<body>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	<div class="container">
	    <div class="row">
	        <div class="mx-auto col-lg-5"><br>
	        <h4> &nbsp; 쿼리 작업</h4><br>
        	<form id="queryForm" name="queryForm">
				<textarea id="queryInput" name="queryInput" placeholder="쿼리문을 작성해주세요." 
				 			style="width:100%; height:100%; font-size:1.1rem;" onkeyup=resize(this)></textarea>
					<button type="button" class="btn btn-primary float-right" onclick="queryExcute();">실행</button>
					<button type="button" class="btn btn-primary float-right" onclick="reset();" style="margin-right:15px;">값 초기화</button>
			</form>
	        </div>
	        
	        <div class="col-sm-5">
	        	<h4> &nbsp; 작업 결과 </h4>
	        	<textarea id="queryResult" name="queryResult" readonly
					placeholder="작업을 실행해주세요." style="width:100%; height:500px;">
				</textarea>
	        </div>
	    </div>
	</div>

</body>
</html>