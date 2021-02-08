<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Couchbase</title>
</head>
<script>
	function randomData() {
		
		var check = inputCheck();
		if(check == false){
			alert('모든 항목을 입력해주세요.');
			return;
		}
		
		var data = jQuery("#randomDataForm").serializeArray();

		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/randomData",
			data : data,
			error : function(xhr, status, error) {
				alert('입력이 잘못되었습니다.');
			},
			success : function(data) {
				alert(data);
			}
		});
	}
	
	function inputCheck(){
		let inputText = $("#randomDataForm input");
		
		for(var i=0;i<inputText.length; i++){
			
			if(inputText[i].value == "" || inputText[i].value == null){
				
				return false;
			}
		}		
		return true;
	}
</script>
<body>
	<!-- header.jsp -->
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	<div class=container>
		<div class=row>
			<div class="mx-auto col-lg-5" ><br>
				<h4> &nbsp; 랜덤 데이터 생성 </h4><br>
					<form id="randomDataForm" name="randomDataForm" class=flexDivCenter>
					
					<div>
						# 아이디 사이즈(Byte)
						<input type="text" id="docIdSize" name="docIdSize"
							onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" /> 
					</div>
					<div>
						# 문서 사이즈 (Byte)
						<input type="text" id="docSize" name="docSize" 
							onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
					</div>
		
					<div>
						# 생성할 문서의 수 <input type="text" name="docCount" 
							onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
					</div>
		
					<div>
						# 쓰레드 수 <input type="text" name="threadCount" 
							onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
					</div>
					
		
					<button type="button" class="btn btn-primary float-right" onclick="randomData();">실행</button>
				</form>
			</div>
		</div>
	</div>
	
</body>
</html>