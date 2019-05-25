package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.YketCourseMapper;
import com.sun3d.why.dao.YketLikeMapper;
import com.sun3d.why.model.vo.yket.RecommandCourseVo;
import com.sun3d.why.service.RecommandService;
import com.sun3d.why.util.RandomUtils;
/**
 * 课程推荐
 * @author Administrator
 *
 */
@Service
public class RecommandServiceImpl implements RecommandService {

	@Autowired
	private YketLikeMapper likeMapper;
	
	@Autowired
	private YketCourseMapper courseMapper;
	@Override
	public List<RecommandCourseVo> recommandCourse() {
		// 初始数据， 判断条件
		List<RecommandCourseVo>  likeList=  likeMapper.recommandCourse();
		if(likeList!=null && likeList.size()==4){
			return likeList;
		}
  		Integer courseCount= courseMapper.countCourse(null);
  		Map<String,Object> conds = new HashMap<String,Object>();
  		conds.put("rows", 1);
  		List<RecommandCourseVo> recommends = new ArrayList<RecommandCourseVo>();
  		if(courseCount>=4){
  		  Object[] rand=RandomUtils.getRandomNumber(courseCount, 4);
  	      for(int i=0;i<rand.length;i++){
  	    	  conds.put("firstResult", rand[i]);
  	         recommends.add(courseMapper.recommandCourse(conds));	
  	      }
  		} 
		// 足迹类别的其他数据 
		return recommends;
 	} 

	
	public static void main(String[] args) {
		
	}
}
