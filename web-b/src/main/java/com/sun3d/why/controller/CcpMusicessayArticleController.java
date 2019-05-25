package com.sun3d.why.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.model.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.service.CcpMoviessayArticleService;
import com.sun3d.why.service.CcpMusicessayArticleService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/musicessayArticle")
@Controller
public class CcpMusicessayArticleController {

	@Autowired
	private CcpMusicessayArticleService musicessayArticleService;
	
	@Autowired
	private CcpMoviessayArticleService moviessayArticleService;
	
	
	/**
	 * 音乐征文列表
	 * @param ccpMusicessayArticle
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/musicessayArticleIndex")
	public ModelAndView musicessayArticleIndex(CcpMoviessayArticleDto ccpMoviessayArticle,Pagination page,String flag){
		ModelAndView model = new ModelAndView();
		if(flag.contains(",")){
			flag = flag.substring(0, 1);
		}
		//音乐：1
		if("1".equals(flag)){
			List<CcpMusicessayArticleDto> list = this.musicessayArticleService.queryMusicessayArticle(ccpMoviessayArticle,page);
			model.addObject("EntityArticle", ccpMoviessayArticle);
			model.addObject("list", list);
		}else{
			//电影：2
			List<CcpMoviessayArticleDto> list = this.moviessayArticleService.queryMoviessayArticle(ccpMoviessayArticle, page);
			model.addObject("EntityArticle", ccpMoviessayArticle);
			model.addObject("list", list);
		}
		model.addObject("page", page);
		model.addObject("flag", flag);
		
		
		//返回结果集
		model.setViewName("admin/musicessayArticle/musicessayArticleIndex");
		return model;
	}
	
	/**
	 * 删除
	 * @param articleId
	 * @return
	 */
	@RequestMapping(value="/del",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deletedMusicessayArticle(String articleId,String flag){
		
		if("1".equals(flag)){
			//音乐
			return this.musicessayArticleService.deletedMusicessayArticle(articleId);
		}else{
			//电影
			return this.moviessayArticleService.deletedMoviessayArticle(articleId);
		}
	}
	
	/**
	 * 文章内容查看
	 * @param articleId
	 * @return
	 */
	@RequestMapping(value="/lookTitle")
	public ModelAndView look(String articleId,String flag){
		
		ModelAndView model = new ModelAndView();
		if("1".equals(flag)){
			CcpMusicessayArticle musicessayArticle = this.musicessayArticleService.queryMusicessayArticleById(articleId);
			model.addObject("EntityArticle", musicessayArticle);
			model.setViewName("admin/musicessayArticle/lookTitle");
		}else{
			CcpMoviessayArticleDto moviessayArticle = this.moviessayArticleService.queryMoviessayArticleById(articleId);
			model.addObject("EntityArticle", moviessayArticle);
			model.setViewName("admin/musicessayArticle/lookTitle");
		}
		return model;
	}
	
	
	
	
	@RequestMapping(value="/checkMessage")
	public ModelAndView check(String articleId,String flag){
		ModelAndView model = new ModelAndView();
		if("1".equals(flag)){
			CcpMusicessayArticle musicessayArticle = this.musicessayArticleService.checkMessage(articleId);
			model.addObject("EntityArticle", musicessayArticle);
		}else{
			CcpMoviessayArticleDto moviessayArticle = this.moviessayArticleService.checkMessage(articleId);
			model.addObject("EntityArticle", moviessayArticle);
		}
		model.addObject("flag", flag);
		model.setViewName("admin/musicessayArticle/checkAll");
		return model;
	}
	
	
	
	
	@RequestMapping(value="/brushWalkVote")
	@ResponseBody
	public Map<String, Object> brushWalkVote(String articleId,Integer articleLike,String flag){
		if("1".equals(flag)){
			return this.musicessayArticleService.updateVote(articleId,articleLike);
		}else{
			return this.moviessayArticleService.updateVote(articleId,articleLike);
		}
		
	}
	
	
	
}
