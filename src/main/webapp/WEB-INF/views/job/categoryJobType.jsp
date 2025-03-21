<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function() {
			$("#fetchJobData").click(function() {
				$.ajax({
					url : "/job/fetch",
					type : "GET",
					success : function(response) {
						alert("데이터가 성공적으로 저장되었습니다.");
					},
					error : function() {
						alert("데이터 저장 실패!");
					}
				});
			});
		});
		
		$(document).ready(function(){
		    $("#fetchSubcategoryData").click(function(){
		        $.ajax({
		            url: "/job/fetchSubcategory",
		            type: "GET",
		            success: function(response) {
		                alert("소분류 데이터가 성공적으로 저장되었습니다.");
		            },
		            error: function() {
		                alert("소분류 데이터 저장 실패!");
		            }
		        });
		    });
		});
	</script>
	
<body>
	<button id="fetchJobData">직업 데이터 가져오기</button>
	
	<button id="fetchSubcategoryData">직업 소분류 데이터 가져오기</button>
</body>
</html>