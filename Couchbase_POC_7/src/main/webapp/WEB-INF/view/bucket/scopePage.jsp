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
<Script>
	function moveDocumentPage(scopeName, collectionName){
		
		let url = "<%= request.getContextPath()%>"+"/documents/documentPage?bucketName=";
				url += '${bucketName}';
				url += '&scopeName=';
				url += scopeName;
				
		if(collectionName!=undefined){
			url += "&collectionName=";
			url += collectionName;
		}
		
		window.close();
		opener.location.href=url;
	}
	
	function addScope(bucketName){
		window.open('addScopePage?bucketName='+bucketName,'뉴팝업','width=400, height=400, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
	}
	
	function addCollection(bucketName, scopeName){
		window.open('addCollectionPage?bucketName='+bucketName+"&scopeName="+scopeName,'뉴팝업','width=400, height=400, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no');
	}
	
	function dropScope(bucketName, scopeName){
		if(confirm(scopeName+' Scope를 삭제하시겠습니까?')){
			
			$.ajax({
				
				url:"<%=request.getContextPath()%>/dropScope?bucketName="+bucketName+"&scopeName="+scopeName,
				type:"post",
				error : function(xhr,status,error) {
					alert(error);
				},
				success : function(data){
					alert(data);
					if(data.includes("삭제")){
						location.reload();
					}
				}
				
			});
		}
	}
	
	function dropCollection(bucketName, scopeName, collectionName){
		if(confirm(collectionName+' Collection을 삭제하시겠습니까?')){
			
			$.ajax({
				
				url:"<%=request.getContextPath()%>/dropCollection?bucketName="+bucketName+"&scopeName="+scopeName+"&collectionName="+collectionName,
				type:"post",
				error : function(xhr,status,error) {
					alert(error);
				},
				success : function(data){
					alert(data);
					if(data.includes("삭제")){
						location.reload();
					}
				}
				
			});
		}
	}

</Script>
</head>
<body>

	<br>
	<div class=container>
		<h5 style=text-align:center;> Bucket [ ${bucketName } ] </h5>
		<span style=float:right;>
			<a href=# onclick="addScope('${bucketName}')">Add Scope</a>	
		</span>
		<br><br>
		<c:forEach items="${scopeList }" var="list">
			<div class="card">
				<div class="card-header">
					${list.key }
					<span style=float:right;>
						<a href=# onclick="moveDocumentPage('${list.key}')">Documents</a> | 
						<a href=# onclick="addCollection('${bucketName }','${list.key}')">Add Collection</a>
						<c:if test="${list.key ne '_default'}">
							<a href=# onclick="dropScope('${bucketName }','${list.key}')">| Drop</a>
						</c:if>
					</span>
				</div>
				<br>
				<div class="card-block">
					<blockquote class="card-blockquote">
						<c:forEach items="${list.value }" var="value">
						
							<span style="margin-left:30px;">${value} </span>
							
							<span style=float:right;margin-right:10px;>
								<a href=# onclick="moveDocumentPage('${list.key}','${value}')">Documents</a>
								<c:if test="${value ne '_default'}">
									<a href=# onclick="dropCollection('${bucketName }','${list.key }','${value}')">| Drop</a>
								</c:if>
							</span>
							<br>
							
						</c:forEach>
					</blockquote>
				</div>
			</div>
			<br>
		</c:forEach>
	</div>



</body>
</html>