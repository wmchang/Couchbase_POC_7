<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
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
<%
	String limit = request.getParameter("limit");

	if(limit == null)
		limit = "30"; 
	
%>
</head>

<script>

	function openDocument(docId){
		
		var document_window = window.open('documentDetails?documentId='+docId+'&bucketName=${bucketName}&scopeName=${scopeName}&collectionName=${collectionName}','팝업','width=550, height=570, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no')
	}
	
	function newDocument(){
		
		var document_window = window.open('newDocument?bucketName=${bucketName}&scopeName=${scopeName}&collectionName=${collectionName}','팝업스','width=550, height=570, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no')
	}
	
	function docBucketChange(){
		if(document.getElementById("bucketName").value=='-Select Bucket-')
			return;
		
		document.getElementById("documentPageForm").submit();
	}
	
	function scopeOrCollectionChange(){

		document.getElementById("documentPageForm").submit();
	}
	
	function createPrimaryIndex(){
		
		$.ajax({
			type : "post",
			url : "<%= request.getContextPath()%>/createPrimaryIndex?bucketName=${bucketName }",
			error : function(xhr, status, error) {
				alert(error);
			},
			success : function(data) {
				
				if(data.includes("생성")){
					alert(data);
					location.reload();
				}
				else if(data.includes('IndexExistsException')){
					
					if(confirm('인덱스가 이미 존재합니다. 문서를 생성하시겠습니까?')){
						newDocument();
					}
				}
				else if(data.includes('IndexFailureException')){
					alert('Memcached 버킷은 지원하지않습니다.');
				}
				else {
					alert(data);
				}
			}
		}); 
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
						<h5> &nbsp; 또한 Memcached 버킷은 조회가 불가능합니다.</h5>
						<button type="button" class="btn btn-primary" onclick="createPrimaryIndex();">Primary Index 생성</button>
					</c:if>
	
					<c:if test="${not empty documentList}">
					<div style="float:right;">
						<form id=documentPageForm action=documentPage style=display:inline-block;>
						
							<label >Bucket:</label>
							<select name=bucketName onchange=docBucketChange() id=bucketName>
									<option value='-Select Bucket-'>-Select Bucket-</option>
								<c:forEach items="${bucketList }" var="list">
									<option value=${list } <c:if test="${list eq bucketName}">selected</c:if>>${list }</option>
								</c:forEach>
							</select>
						
							<label >Scope:</label>
							<select name=scopeName onchange=scopeOrCollectionChange() id=scopeName>
								<c:forEach items="${scopeList }" var="list">
									<option value=${list } <c:if test="${list eq scopeName}">selected</c:if> >${list }</option>
								</c:forEach>
							</select>
							
							<label >Collection:</label>
							<select name=collectionName onchange=scopeOrCollectionChange() id=collectionName>
								<c:forEach items="${collectionList }" var="list">
									<option value=${list } <c:if test="${list eq collectionName}">selected</c:if> >${list }</option>
								</c:forEach>
							</select>
						
							<label>limit: </label>
							<input type=text name=limit value=<%=limit %>>
							
							
						</form>
					
						<button class="btn btn-primary" onclick="newDocument();">Document 추가</button>
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
								
									<c:choose>
									
										<c:when test="${list.id eq 'emptyDocumentList'}">
											<td colspan=2> ${list.content }</td>
										</c:when>
										
										<c:otherwise>
											<td><a href="#" onclick="openDocument('${list.id}')" class=overText>${list.id }</a></td>
											<td class=overText>${list.content }</td>
										</c:otherwise>
										
									</c:choose>
								</tr>
							</c:forEach>
						</table>
					</c:if>
	
			</div>
		</div>
	</div>
	


</body>
</html>