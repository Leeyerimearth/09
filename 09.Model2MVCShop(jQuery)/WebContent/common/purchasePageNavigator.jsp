<%@ page contentType="text/html; charset=euc-kr" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
	<c:if test="${ resultPage.currentPage > resultPage.pageUnit }">
		<!--
		<a href="javascript:fncGetUserList('${ resultPage.currentPage-1}')">◀ 이전</a>
		 -->
		 <td id="before">◀ 이전</td>
	</c:if>
	
	<c:forEach var="i"  begin="${resultPage.beginUnitPage}" end="${resultPage.endUnitPage}" step="1">
		<a href="javascript:fncGetPurchaseList('${i}');">${i}</a>
	</c:forEach>
	
	<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
		<!--  
		<a href="javascript:fncGetUserList('${resultPage.endUnitPage+1}')">이후 ▶</a>
		-->
		<td id="after">이후 ▶</td>
	
	</c:if>