<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<!-- header.jsp -->
	<c:import url="/WEB-INF/view/common/header.jsp">
	</c:import>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script src=https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js></script>
<script>

	let ramChart;
	let diskChart;
	
	$(document).ready(function(){
		
		
		createChart('ramChart');
		createChart('diskChart');
		
		
		let labels = [];
		let disks = [];
		let rams = [];

 		setInterval(function(){
 			
 	 		$.ajax({
 	 			
 				type : "post",
 				url : "<%= request.getContextPath()%>/getResource",
 				error : function(xhr, status, error) {
 					alert(error);
 				},
 				success : function(data) {
 					
 		 	 		/* myChart.data.datasets[0].labels = data[1];
 					myChart.update(); */
 					
 					for(var i=0;i<data[0].length;i++){
 						labels = data[0][i];
 						disks = data[1][i];
 						rams = data[2][i];
 					}
 				}	
 			}); 
 	 		
 	 		ramChart.data.datasets[0].data = disks;
 	 		diskChart.data.datasets[0].data = rams;

	    }, 5000);  


		
	});
	
	function createChart(chartId){
		var ctx = document.getElementById(chartId).getContext('2d');
		
		ramChart = new Chart(ctx, {
		    // The type of chart we want to create
		    type: 'line',

		    // The data for our dataset
		    data: {
		        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
		        datasets: [{
		            label: 'Ram Used',
		            borderColor: 'rgb(255, 99, 132)',
		            data: [0,1,2]
		        }
		        /* ,{ 
		        	label: 'hi',
		            borderColor: 'rgb(0, 0, 0)',
		            data: [15, 20, 35, 45, 90, 105, 120]
		        } >>> 한 차트에 여러 데이터셋 */
		        
		        ]
		    },

		    // Configuration options go here
		    options: {
				responsive: false,
				scales: {
					yAxes: [{
						ticks: {
							beginAtZero: true
						}
					}]
				},
			}
		});
		
	}
	
	function getRamUsed(){
		
		
	}
	
</script>
</head>
<body>
	<br>
	<div class=container>
		<canvas id="ramChart" width="400" height="400" style="display:inline-block;"></canvas>
		<canvas id="diskChart" width="400" height="400" style="display:inline-block;" ></canvas>
	</div>
</body>
</html>