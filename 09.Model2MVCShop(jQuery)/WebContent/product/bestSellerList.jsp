<%@ page contentType="text/html; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
<%@ page import="java.util.*"  %>
<%@ page import="com.model2.mvc.service.domain.Purchase" %>
<%@ page import="com.model2.mvc.service.domain.User" %>
<%@ page import="com.model2.mvc.common.*" %>

<%
	User user =(User)session.getAttribute("user");

	List<Purchase> list=(List<Purchase>)request.getAttribute("list");
	Search search=(Search)request.getAttribute("search");
	Page resultPage = (Page)request.getAttribute("resultPage");
	/*
	int total=0;
	ArrayList<Purchase> list=null;
	if(map != null){
		total=((Integer)map.get("count")).intValue();
		list=(ArrayList<Purchase>)map.get("list");
	}
	
	int currentPage=search.getCurrentPage();
	*/
%>

--%>

<html>
<head>
<title>베스트 top 10</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>

<script type="text/javascript">
	function fncGetProduct() {
		//document.getElementById("currentPage").value = currentPage;
		
		$("form").attr("method","POST").attr("action","/product/getProduct").submit();
		//document.detailForm.submit();
	}
	
	$(function(){
		
		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			//Debug..
			alert( $(this).find('input').val());
			self.location ="/product/getProduct?prodNo="+$(this).find('input').val();
			
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
		$("h7").css("color" , "red");	
		
		//==> 아래와 같이 정의한 이유는 ??
		//==> 아래의 주석을 하나씩 풀어 가며 이해하세요.					
		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
		//console.log ( $(".ct_list_pop:nth-child(1)" ).html() );
		//console.log ( $(".ct_list_pop:nth-child(2)" ).html() );
		//console.log ( $(".ct_list_pop:nth-child(3)" ).html() );
		console.log ( $(".ct_list_pop:nth-child(4)" ).html() ); //==> ok
		//console.log ( $(".ct_list_pop:nth-child(5)" ).html() ); 
		//console.log ( $(".ct_list_pop:nth-child(6)" ).html() ); //==> ok
		//console.log ( $(".ct_list_pop:nth-child(7)" ).html() ); 
	
	});
	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">베스트 top 10</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11"></td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">제품명<br>
			<h7 >(상품명 click:상세정보)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">미리보기</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">제품상세정보</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	
	<c:set var="i" value="0" />
	<c:forEach var="product" items ="${list}">
		<c:set var="i" value="${i+1}"/>
		<tr class="ct_list_pop">
		<td align="center">
			${i}
		</td>
		<td></td>
		<td align="left">
			<input type="hidden" id="prodNo" name="prodNo" value="${product.prodNo}"/>
			<%-- <a href="/getUser.do?userId=${user.userId}">${user.userId}</a>--%>
			${product.prodName}
		</td>
		<td></td>
		<td align="left">
		<fmt:formatNumber value="${product.price}" groupingUsed="true"/>
		</td>
		<td></td>
		<td align="left" width="150">
			<img src = "/images/uploadFiles/${product.fileName}" width="150" height="150"/>
		</td>
		<td></td>
		<td align="center">
			${product.prodDetail}
		</td>
		<td></td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>

	</c:forEach>
</table>


<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>