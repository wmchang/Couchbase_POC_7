<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/index.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"><!-- 합쳐지고 최소화된 최신 자바스크립트 -->

<title>Couchbase</title>
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
		
		window.open('/documents/documentDetails?documentId='+docId+'&bucketName=${bucketName}','팝업스','width=650, height=600, left='+left+', top='+popupY+', menubar=no, status=no, toolbar=no')
		
	}
</script>

<body>
	
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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