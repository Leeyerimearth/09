<%@ page contentType="text/html; charset=euc-kr" %>

<%--
<%@ page import ="com.model2.mvc.service.domain.Product" %>
<%@ page import ="com.model2.mvc.service.domain.User" %>

<%
	Product product = (Product)session.getAttribute("vo");
	User user = (User)session.getAttribute("user");
%>

 --%>
 
<html>
<head>
<title>Insert title here</title>
</head>

<body>

<form name="updatePurchase" action="/purchase/updatePurchase?tranNo=0" method="post">

������ ���� ���Ű� �Ǿ����ϴ�.

<table border=1>
	<tr>
		<td>���� ��ǰ</td>
		<td>${sessionScope.vo.prodName}</td>
		<td></td>
	</tr>
	<tr>
		<td>���� ����</td>
		<td>${param.quantity}</td>
		<td></td>
	</tr>
	<tr>
		<td>�� ���Ű���</td>
		<td>${(param.quantity)*(sessionScope.vo.price)}</td>
		<td></td>
	</tr>
	
	<tr>
		<td>�����ھ��̵�</td>
		<td>${user.userId}</td>
		<td></td>
	</tr>
	<tr>
		<td>���Ź��</td>
		<td>
			${param.paymentOption}
		</td>
		<td></td>
	</tr>
	<tr>
		<td>�������̸�</td>
		<td>${param.receiverName}</td>
		<td></td>
	</tr>
	<tr>
		<td>�����ڿ���ó</td>
		<td>${param.receiverPhone}</td>
		<td></td>
	</tr>
	<tr>
		<td>�������ּ�</td>
		<td>${param.divyAddr}</td>
		<td></td>
	</tr>
		<tr>
		<td>���ſ�û����</td>
		<td>${param.divyRequest}</td>
		<td></td>
	</tr>
	<tr>
		<td>����������</td>
		<td>${param.divyDate}</td>
		<td></td>
	</tr>
</table>
</form>

</body>
</html>