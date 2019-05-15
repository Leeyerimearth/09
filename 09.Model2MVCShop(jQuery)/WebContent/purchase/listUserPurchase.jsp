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
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">


<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
	function fncGetPurchaseList(currentPage) {
		
		$("#currentPage").val(currentPage);
		$('form').attr("method","POST").attr("action","/purchase/listPurchase").submit();
		//document.getElementById("currentPage").value = currentPage;
		//document.detailForm.submit();
	
	}
	
	$(function(){
		
		
		$( ".ct_list_pop td:nth-child(1)" ).on("click" , function() {
			//Debug..
				//alert( $('input[id=prodNo]').val() );
				alert( $(this).find('input').val()); //$('input[id=prodNo]').val() );
				///purchase/getPurchase?tranNo=${purchase.tranNo}
			self.location ="/purchase/getPurchase?tranNo="+$(this).find('input').val();
		
		});
	
		$( ".ct_list_pop td:contains('물건도착')" ).on("click" , function() {
			//Debug..
				
				alert($(this).find("input[id=currentPage1]").val() ); //$('input[id=prodNo]').val() );
				///purchase/updateTranCode?tranNo=${purchase.tranNo}&currentPage=${resultPage.currentPage}
			self.location ="/purchase/updateTranCode?tranNo="+$(this).parent().find("input[id=tranNo]").val()
					+"&currentPage="+$(this).find("input[id=currentPage1]").val();
		
		});
		
		
		$("#before").on("click", function(){
			
			fncGetUserList('${ resultPage.currentPage-1}');
		})
		
		$("#after").on("click", function(){
			
			fncGetUserList('${resultPage.endUnitPage+1}');
		})
		
	
		//1번째 인자 No를 색변경
		$( ".ct_list_pop td:nth-child(1)" ).css("color" , "red");
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

<form name="detailForm" action="/purchase/listPurchase" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록 조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage} 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No<br>
			<h7 >(No click:상세정보)</h7> </td>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">제품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">총 구매가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">구매 개수</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">구매일</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
	<%-- 
	<% 	
		int no=list.size();
		String code =null;
		for(int i=0; i<list.size(); i++) {
			Purchase vo = (Purchase)list.get(i);
			code = vo.getTranCode();
			
			if(code.equals("001"))
				code="판매중";
			else if(code.equals("002"))
				code="배송중";
			else if(code.equals("003"))
				code="배송완료";
			else if(code.equals("004"))
				code="구매완료";
	%>
	--%>
	<c:set var="i" value="0" />
	<c:forEach var="purchase" items ="${list}">
		<c:set var="i" value="${i+1}"/>
		<tr class="ct_list_pop">
		<td align="center">
			<input type="hidden" id="tranNo" name="tranNo" value="${purchase.tranNo}"/>
			<!-- ///////////////////////////////////////////////////////////////////////
			<a href="/purchase/getPurchase?tranNo=${purchase.tranNo}">${i}</a>
			//////////////////////////////////////////////////////////////////////////////
			-->
			${i}
		</td>
		<td></td>
		<td align="left">
			<%-- <a href="/getUser.do?userId=${user.userId}">${user.userId}</a>--%>
			${purchase.purchaseProd.prodName}
		</td>
		<td></td>
		<td align="left">
		<fmt:formatNumber value="${purchase.purchaseProd.price}" groupingUsed="true"/>
		</td>
		<td></td>
		<td align="left">${purchase.buyQuantity}</td>
		<td></td>
		<td align="left">${purchase.orderDate}</td>
		<td></td>
		<td align="left">
		<c:if test="${purchase.tranCode=='001'}">
			판매중
		</c:if>
		<c:if test="${purchase.tranCode=='002'}">
			배송중		
		
			<input type="hidden" id ="currentPage1" name="currentPage1" value="${resultPage.currentPage}"/>
			<!-- 
			<a href="/purchase/updateTranCode?tranNo=${purchase.tranNo}&currentPage=${resultPage.currentPage}">물건도착</a>
			-->
			물건도착
		</c:if>
		<c:if test="${purchase.tranCode=='003'}">
			배송완료
		</c:if>
		<c:if test="${purchase.tranCode=='004'}">
			구매완료
		</c:if>
		</td>
		<td></td>
		<%--
		<td align="left">
			<%
				if(code.equals("배송중")){
			%>
			<a href="/updateTranCode.do?prodNo=<%=vo.getPurchaseProd().getProdNo() %>">물건도착</a>
			<%} %>
		</td>
		--%>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	<%--<%} %> --%>
	</c:forEach>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
		 <input type="hidden" id="currentPage" name="currentPage" value=""/>
			
			 	<jsp:include page="../common/purchasePageNavigator.jsp"/>
			
		</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>