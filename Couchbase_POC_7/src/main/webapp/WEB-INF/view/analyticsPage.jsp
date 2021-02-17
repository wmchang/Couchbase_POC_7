<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- header.jsp -->
<c:import url="/WEB-INF/view/common/header.jsp" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
				url : "<%= request.getContextPath()%>/analyticsQuery",
				data : data,
				error : function(xhr, status, error) {
					$('#queryResult').val(error);
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
		  obj.style.height = (29+obj.scrollHeight)+"px";
	}
</script>
</head>
<body>

	<div class="container">
		<div class="row">
		
	        <div class="mx-auto col-lg-5"><br>
	        	<h4> &nbsp; Analytics Query </h4><br>
	            <form id="queryForm" name="queryForm">
					<textarea id="queryInput" name="queryInput" placeholder="Query를 작성해주세요." 
				 			style="width:100%; height:100%; font-size:1.1rem;" onkeyup="resize(this)">SELECT * FROM Metadata.`Dataverse`;</textarea>
					<button type="button" class="btn btn-primary float-right" onclick="queryExcute();">실행</button>
					<button type="button" class="btn btn-primary float-right" onclick="reset();" style="margin-right:15px;">값 초기화</button>
				</form>	
	        </div>
	        
	        <div class="mx-auto col-lg-5"><br>
	        	<h4> &nbsp; Result </h4><br>
	        	<textarea id="queryResult" name="queryResult" readonly	placeholder="" style="width:100%; height:500px;">
	        	
				</textarea>
	        
	        </div>
	    </div>
	</div>

</body>
</html>