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
		
		var check = inputCheck($("#randomDataForm"));
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
				alert(error);
			},
			success : function(data) {
				alert(data);
			}
		});
	}
	
	
	function bucketChange(){
		if(document.getElementById("bucketName").value=='-Select Bucket-')
			return;
		
		let bucketName = $('#bucketName').val();
		let scopeName = $('#scopeName').val();
		let collectionName = $('#collectionName').val();
		
		location.href="<%= request.getContextPath()%>/randomDataPage?bucketName="+bucketName+"&scopeName="+scopeName+"&collectionName="+collectionName;
		
		
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
				
					<c:if test="${empty bucketName}">
						<h5> 서버를 연결해주세요.</h5>
					</c:if>


					<c:if test="${not empty bucketName}">

						<form id="randomDataForm" name="randomDataForm" class=flexDivCenter>
						
						<div>
							<label ># Bucket</label>
							<select name=bucketName onchange=bucketChange() id=bucketName>
									<option value='-Select Bucket-'>-Select Bucket-</option>
								<c:forEach items="${bucketList }" var="list">
									<option value=${list } <c:if test="${list eq bucketName}">selected</c:if>>${list }</option>
								</c:forEach>
							</select>
						</div>
						<div>
						<label ># Scope</label>
						<select name=scopeName onchange=bucketChange() id=scopeName>
							<c:forEach items="${scopeList }" var="list">
								<option value=${list } <c:if test="${list eq scopeName}">selected</c:if> >${list }</option>
							</c:forEach>
						</select>
						</div>
						
						<div>
						<label ># Collection</label>
						<select name=collectionName id=collectionName>
							<c:forEach items="${collectionList }" var="list">
								<option value=${list } <c:if test="${list eq collectionName}">selected</c:if> >${list }</option>
							</c:forEach>
						</select>
						</div>
						
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
				</c:if>
			</div>
		</div>
	</div>
	
</body>
</html>