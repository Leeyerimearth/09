package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserDao;
import com.model2.mvc.service.user.UserService;

@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	
	@Autowired // point update
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	public PurchaseController() {
		System.out.println(this.getClass()+"컨트롤러 생성자");
	}
	
	@RequestMapping(value="addPurchase",method=RequestMethod.POST)
	public String addPurchase(HttpSession session,@RequestParam("usePoint") int usePoint,
								@ModelAttribute("purchase") Purchase purchase,Model model) throws Exception
	{
		System.out.println("/purchase/addPurchase POST방식");
		
		User user = (User) session.getAttribute("user");
		Product product = (Product) session.getAttribute("vo");
		
	
		//////////////////////////////////////////////////////////사용포인트감소
		if(usePoint > 0) {
			
			int updatePoint = user.getUserPoint()-usePoint;
			System.out.println("updatePoint : "+updatePoint);
			user.setUserPoint(updatePoint); // 포인트깎기
		
			userService.updateUser(user,"subPoint"); //user update//
		}
		////////////////////////////////////////////////////////////////////
		
		// 그래서 총 결제한 금액 -> 나중에 user table에 넣을거임.. 이고객이 얼마나 썼는지(배송완료하면)
		// 그리고 transaction table에 넣을까? colum추가해서. 그래야 나중에 포인트 쌓일때, 가져와서 거기서 0.02프로를해주지
		int resultPayMoney = purchase.getBuyQuantity()*product.getPrice() - usePoint;
		
		//총 구매가격 빼야함 userDB, addPurchaseTable.jsp에서
		
		//product.setQuantity(quantity);
		purchase.setBuyer(user);
		purchase.setPurchaseProd(product);
		
		////////////////////////////////////////////////////
		purchase.setPayAmount(resultPayMoney); //purchase
		////////////////////////////////////////////////////
		
		model.addAttribute("requestPvo", product);
		purchaseService.addPurchase(purchase);
		
		
		return "forward:/purchase/addPurchaseTable.jsp";
	}
	
	@RequestMapping(value="addPurchase", method=RequestMethod.GET)
	public String addPurchase()
	{
		System.out.println("/purchase/addPurchase GET방식");
		
		return "forward:/purchase/addPurchase.jsp";
	}
	
	@RequestMapping(value="getPurchase", method=RequestMethod.GET)
	public String getPurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception
	{
		System.out.println("/purchase/getPurchase");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping(value="updatePurchase", method=RequestMethod.GET)
	public String updatePurchase(@RequestParam("tranNo") int tranNo, Model model) throws Exception
	{
		System.out.println("/purchase/updatePurchase GET 방식");
		
		Purchase purchase = purchaseService.getPurchase(tranNo);
		
		model.addAttribute("purchase", purchase);
		
		return "forward:/purchase/updatePurchase.jsp";
	}
	
	@RequestMapping(value="updatePurchase", method = RequestMethod.POST)
	public String updatePurchase(@RequestParam("tranNo") int tranNo,
							@ModelAttribute("purchase") Purchase purchase,Model model) throws Exception
	{
		System.out.println("/purchase/updatePurchase POST 방식");
		
		Purchase sqlPurchase = purchaseService.getPurchase(tranNo);
		sqlPurchase.setPaymentOption(purchase.getPaymentOption());
		sqlPurchase.setReceiverName(purchase.getReceiverName());
		sqlPurchase.setReceiverPhone(purchase.getReceiverPhone());
		sqlPurchase.setDivyAddr(purchase.getDivyAddr());
		sqlPurchase.setDivyRequest(purchase.getDivyRequest());
		sqlPurchase.setDivyDate(purchase.getDivyDate().substring(0, 10));
		
		purchaseService.updatePurcahse(sqlPurchase);
		sqlPurchase = purchaseService.getPurchase(tranNo);
		
		model.addAttribute("purchase", sqlPurchase);
		
		return "forward:/purchase/getPurchase.jsp";
	}
	
	@RequestMapping("listPurchase")
	public String listPurchase(HttpSession session,
								@ModelAttribute("search") Search search,Model model) throws Exception
	{
		
		System.out.println("/purchase/listPurchase");
		
		Map<String,Object> map = null;
		
		User user = (User) session.getAttribute("user");
		System.out.println(user);
		
		
		if(search.getCurrentPage()==0)
		{
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize); // 하면 start end rownum 만듬
		
		//String admin = "1";
		
		//if(user.getRole().equals("admin"))// admin이면 null 보내서, transaction table 다가져옴 //근데 admin의 구매정보는 볼수없자낭
			//map = purchaseService.getPurchaseList(search, admin);
		//else
			map = purchaseService.getPurchaseList(search, user.getUserId());
		
		Page resultPage = 
				new Page(search.getCurrentPage(),((Integer)map.get("totalCount")).intValue(),pageUnit,pageSize);

		model.addAttribute("list", map.get("list"));
		model.addAttribute("search", search);
		model.addAttribute("resultPage", resultPage);
		
		//return도 다르게 해줘야함
		
		if(user.getRole().equals("admin"))
			return "forward:/purchase/listPurchase.jsp";   // 수정 new jsp
		else // 일반 유저
			return "forward:/purchase/listUserPurchase.jsp"; 
	}
	
	@RequestMapping("listSale")
	public String listSale(@ModelAttribute("search") Search search, HttpSession session,
								@RequestParam("menu") String menu,Model model) throws Exception
	{
		System.out.println("/purchase/listSale");
		
		if(search.getCurrentPage()==0)
		{
			search.setCurrentPage(1);
		}
		
		search.setPageSize(pageSize);
		
		Map<String,Object> map = purchaseService.getSaleList(search);
		session.setAttribute("menu", menu);
		
		Page resultPage = 
				new Page(search.getCurrentPage(),((Integer)map.get("totalCount")).intValue(),pageUnit,pageSize);

		model.addAttribute("list", map.get("list"));
		model.addAttribute("search", search);
		model.addAttribute("resultPage", resultPage);
		
		return "forward:/product/listProduct2.jsp";
	}
	
	@RequestMapping(value= "updateTranCode" , method= RequestMethod.GET)
	public String updateTranCode(@RequestParam("tranNo") int tranNo, HttpSession session) throws Exception
	{
		
		System.out.println("/purchase/updateTranCode");
		
		//Purchase purchase = purchaseService.getPurchase2(prodNo);
		User user = (User) session.getAttribute("user");
		Purchase purchase = purchaseService.getPurchase(tranNo); //tranNo로 수정
		purchaseService.updateTranCode(purchase);
		
		
		////////////////////////////////////////////////////////////////////////////2%point설정(배송완료됐을때)
		if( Integer.parseInt(purchase.getTranCode())==2)
		{
			//배송완료이면, getproduct해서, userPoint update
			Product product =productService.getProduct(purchase.getPurchaseProd().getProdNo());
			
			//새롭게 추가될 포인트
			int newPoint = (int)(purchase.getBuyQuantity()*product.getPrice()*(0.02));
			System.out.println("userPoint!!! : "+newPoint);
			user.setUserPoint(newPoint);
			
			//transaction의 pay_amount를 user Table의 new user total_Payment의 기존값과 더해준다.
			//이걸 컨트롤러에서 해주는게 맞을까? 컨트롤러의 목적
			user.setTotalPayment(user.getTotalPayment()+purchase.getPayAmount());
			// 						기존의 tatalPayment + 제품에대해 최종 구매한 값
			
			userService.updateUser(user,"addPoint"); //updateUser를 사용할까?
			/////////////////////////////////////////////////////////////////////////
			//
		}	
		//if(user.getUserId().equals("admin")) 수정 왜냐면 user든 admin이든 listPurchase.do로 갈수있다.
			//return "forward:/listSale.do";
		//else
			return "forward:/purchase/listPurchase";
	}

	//@RequestMapping("/updateTranCodeByProd.do") 아니 왜있냐고?
	//public String updateTranCodeByProd()
	//{
		
	//}
}
