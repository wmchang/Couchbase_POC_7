<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<title>Couchbase</title>
<Style>
	.overText{
		    white-space: nowrap;
    text-overflow: ellipsis;
    width: 500px;
    display: block;
    overflow: hidden;
	}
</Style>
</head>
<script>

	function openDocument(docId){
		
		// window.open('documentDetails?documentId=${list.id }','팝업스','width=500, height=300, left=3500, top=300, menubar=no, status=no, toolbar=no');
		
		var popupX = (window.screen.width/2)-(500/2);
		var popupY = (window.screen.height/2)-(500/2);
		var left = (screen.availWidth)-popupX;
		
		if( window.screenLeft < 0){
			left += window.screen.width*-1;
			}
			else if ( window.screenLeft > window.screen.width ){
			left += window.screen.width;
		}
		
		var document_window = window.open('documentDetails?documentId='+docId+'&bucketName=${bucketName}','팝업스','width=550, height=570, left='+left+', top='+popupY+', menubar=no, status=no, toolbar=no')
		
	}
	
	function newDocument(){
		
		var popupX = (window.screen.width/2)-(500/2);
		var popupY = (window.screen.height/2)-(500/2);
		var left = (screen.availWidth)-popupX;
		
		if( window.screenLeft < 0){
			left += window.screen.width*-1;
			}
			else if ( window.screenLeft > window.screen.width ){
			left += window.screen.width;
		}
		
		var document_window = window.open('newDocument?bucketName=${bucketName}','팝업스','width=550, height=570, left='+left+', top='+popupY+', menubar=no, status=no, toolbar=no')
	}
	
	function bucketChange(){
		if(document.getElementById("bucketName").value=='-Select Bucket-')
			return;
		
		document.getElementById("documentPageForm").submit();
	}
</script>
<body>
	
	
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
	
	
	<div class=container>
		<div class=row>
			<div class="col-lg-11 mx-auto">
				<h4> &nbsp; Document <c:if test="${not empty documentList}">  : ${bucketName } Bucket </c:if></h4> 
					<br>
					<c:if test="${empty documentList}">
						<h5> &nbsp; 문서를 확인하려면</h5>
						<h5> &nbsp; 서버 연결 및 환경 설정, 인덱스가 생성되어있는지 확인 해주십시오.</h5>
					</c:if>
	
	
					<c:if test="${not empty documentList}">
					<div style="float:right;">
						<form id=documentPageForm action=documentPage style=display:inline-block;>
							<label>limit: </label>
							<input type=text name=limit placeholder="default=30">
						
							<label >Bucket:</label>
							<select name=bucketName onchange=bucketChange() id=bucketName>
									<option value='-Select Bucket-'>-Select Bucket-</option>
								<c:forEach items="${bucketList }" var="list">
									<option value=${list.name } <c:if test="${list.name eq bucketName}">selected</c:if>>${list.name }</option>
								</c:forEach>
							</select>
						</form>
					
						<button class="btn btn-primary" onclick="newDocument();">Document 추가</button>
					</div>	
					
						<div>
							
						</div>
						<table class="table table-striped table-hover">
							<colgroup>
							    <col width="30%" />
							    <col width="70%" />
							</colgroup>
							<tr>
								<th style="text-align: center;">문서 ID</th>
								<th style="text-align: center;">문서 내용</th>
							</tr>
							<c:forEach items="${documentList }" var="list">
								<tr>
									<td><a href="#" onclick="openDocument('${list.id}')" class=overText>${list.id }</a>
									</td>
	
									<td class=overText>${list.content }</td>
								</tr>
	
							</c:forEach>
						</table>
					</c:if>
	
			</div>
		</div>
	</div>
	


</body>
</html>