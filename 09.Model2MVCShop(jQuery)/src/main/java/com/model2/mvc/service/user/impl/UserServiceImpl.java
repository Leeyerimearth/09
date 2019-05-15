package com.model2.mvc.service.user.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.user.UserService;
import com.model2.mvc.service.user.UserDao;;


//==> 회원관리 서비스 구현
@Service("userServiceImpl")
public class UserServiceImpl implements UserService{
	
	///Field
	@Autowired
	@Qualifier("userDaoImpl")
	private UserDao userDao;
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	
	///Constructor
	public UserServiceImpl() {
		System.out.println(this.getClass());
	}

	///Method
	public void addUser(User user) throws Exception {
		userDao.addUser(user);
	}

	public User getUser(String userId) throws Exception {
		return userDao.getUser(userId);
	}

	public Map<String , Object > getUserList(Search search) throws Exception {
		List<User> list= userDao.getUserList(search);
		int totalCount = userDao.getTotalCount(search);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list );
		map.put("totalCount", new Integer(totalCount));
		
		return map;
	}

	public void updateUser(User user, String pointUseState) throws Exception {
		
		
		//1.제품구매로 보유포인트 증가
		if(pointUseState.equals("addPoint"))
		{	
			int newPoint = user.getUserPoint(); // 새로운 제품 구매하여 얻은 포인트
			int originalUserPoint = this.getUser(user.getUserId()).getUserPoint(); //기존포인트
			user.setUserPoint(newPoint+originalUserPoint); // point더하기
		}
		else if(pointUseState.equals("subPoint")){
			//걍 updateUser만 함
		}
		else {
			// "nothing"일때도 .. 그냥 updateUser만 한다. 연산을 controller에서하는건지.. service에서 하는건지.
			 // 각자의 역할을 다시 한번 생각해 봐야겠다.
		}
		/////////////////////////////////////////////////////////////////////////////////////
		userDao.updateUser(user);
	}

	public boolean checkDuplication(String userId) throws Exception {
		boolean result=true;
		User user=userDao.getUser(userId);
		if(user != null) {
			result=false;
		}
		return result;
	}
}