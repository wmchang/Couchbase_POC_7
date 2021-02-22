<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- no_header.jsp -->
	<c:import url="/WEB-INF/view/common/no_header.jsp">
	</c:import>
<title>Couchbase</title>
</head>
<script>

	function openDocument(docId){
		
		// window.open('documentDetails?documentId=${list.id }','팝업스','width=500, height=300, left=3500, top=300, menubar=no, status=no, toolbar=no');
		
		window.open('/documents/documentDetails?documentId='+docId+'&bucketName=${bucketName}','팝업스','width=650, height=600, left='+_left+', top='+_top+', menubar=no, status=no, toolbar=no')
		
	}
</script>

<body>
	
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

	<div class=container>
		<h4> &nbsp; FTS Result Document</h4>
			<div align=right>
				결과: ${fn:length(documentList) }개
			</div>
		<div style="text-align: center; width:100%;">

				<table class="table table-striped table-hover">
					<tr>
						<th style="text-align: center;">문서 ID</th>
					</tr>
					<c:forEach items="${documentList }" var="list">
						<tr>
							<td><a href="#" onclick="openDocument('${list}')">${list }</a>
							</td>
						</tr>

					</c:forEach>
				</table>

		</div>
	</div>

</body>
</html>