<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Couchbase</title>
</head>
<script>
	
	function getFTS(indexName, bucketName, st) {
		
		if (window.event.keyCode == 13) {
			
			let searchText = st.value;
			let windowText = 'searchResultPage?indexName='+indexName+'&bucketName='+bucketName+'&searchText='+searchText;
			
			var document_window = window.open(windowText,'팝업스','width=550, height=580, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
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
			<div class="mx-auto col-lg-10"><br>
				<h4> &nbsp; Full Text Index 목록</h4><br>
				
					<div>
					<c:if test="${empty FTIList}">
	
						<h5>Full Text Index를 확인하려면 서버 연결 및 환경 설정을 해주십시오.</h5>
						<h5>그리고 해당 버킷의 Full Text Index를 생성해주세요.</h5>
					</c:if>
	
	
					<c:if test="${not empty FTIList}">
						<table class="table table-striped table-hover">
							<tr>
								<th style="text-align: center;">bucket name</th>
								<th style="text-align: center;">index name</th>
								<th style="text-align: center;">Search</th>
							</tr>
							<c:forEach items="${FTIList }" var="list">
								<tr>
									<td style=width:33%;>${list.bucket }</td>
									<td style=width:33%;>${list.name }</td>
									<td style=width:33%;><input type=text class=doc style=width:150px; id=searchText name="searchText" onkeyup="getFTS('${list.name}','${list.bucket }',this)"></td>
								</tr>
							</c:forEach>
						</table>
					</c:if>
	
				</div>
			</div>
		</div>
	</div>
	


</body>
</html>