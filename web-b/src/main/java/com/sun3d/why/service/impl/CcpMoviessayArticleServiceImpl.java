package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.sun3d.why.dao.ccp.CcpMoviessayArticleMapper;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.service.CcpMoviessayArticleService;
import com.sun3d.why.util.Pagination;
@Service
public class CcpMoviessayArticleServiceImpl implements CcpMoviessayArticleService {
	
	@Autowired
	private CcpMoviessayArticleMapper  moviessayArticleMapper;

	@Override
	public List<CcpMoviessayArticleDto> queryMoviessayArticle(CcpMoviessayArticleDto ccpMoviessayArticle,Pagination page) {
			Map<String, Object> map = new HashMap<String, Object>();
			if(ccpMoviessayArticle.getArticleType() != null){
				map.put("articleType", ccpMoviessayArticle.getArticleType());
			}
			if(!StringUtils.isEmpty(ccpMoviessayArticle.getUserRealName())){
				map.put("userRealName", "%"+ccpMoviessayArticle.getUserRealName()+"%");
			}
			if(!StringUtils.isEmpty(ccpMoviessayArticle.getUserMoblieNo())){
				map.put("userMoblieNo", "%"+ccpMoviessayArticle.getUserMoblieNo()+"%");
			}
			if(ccpMoviessayArticle.getArticleIsDel() != null){
				map.put("articleIsDel", ccpMoviessayArticle.getArticleIsDel());
			}
			if(ccpMoviessayArticle.getThemeType() !=null){
				map.put("themeType", ccpMoviessayArticle.getThemeType());
			}
			if(page!=null){
				map.put("firstResult", page.getFirstResult());
				map.put("rows", page.getRows());
				int total = this.moviessayArticleMapper.queryMovieArticleCount(map);
				// 设置分页的总条数来获取总页数
				page.setTotal(total);
			}			
			return this.moviessayArticleMapper.queryMoviessayArticleByList(map);
	}

	
	

	@Override
	public Map<String, Object> deletedMoviessayArticle(String articleId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isEmpty(articleId)){
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		CcpMoviessayArticle moviessayArticle = this.moviessayArticleMapper.selectByPrimaryKey(articleId);
		if(moviessayArticle == null){
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		
		if(moviessayArticle.getArticleIsDel()==0){
			moviessayArticle.setArticleIsDel(1);
		}else if(moviessayArticle.getArticleIsDel()==1){
			moviessayArticle.setArticleIsDel(0);
		}else{
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		int rs = this.moviessayArticleMapper.updateByPrimaryKeySelective(moviessayArticle);
		if(rs > 0){
			map.put("status", "ok");
			map.put("msg", "操作成功！");
			return map;
		}
		map.put("status", "error");
		map.put("msg", "操作失败！");
		return map;
	}

	
	

	@Override
	public CcpMoviessayArticleDto queryMoviessayArticleById(String articleId) {
		return this.moviessayArticleMapper.selectByPrimaryKey(articleId);
	}
	
	
	

	@Override
	public CcpMoviessayArticleDto checkMessage(String articleId) {
		return this.moviessayArticleMapper.checkMessage(articleId);
	}

	
	
	
	@Override
	public Map<String, Object> updateVote(String articleId, Integer articleLike) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isEmpty(articleId)){
			map.put("status", "error");
			map.put("msg", "刷票异常，请稍候再试！");
			return map;
		}
		CcpMoviessayArticleDto moviessayArticle = this.moviessayArticleMapper.selectByPrimaryKey(articleId);
		if(moviessayArticle == null){
			map.put("status", "error");
			map.put("msg", "刷票异常，请稍候再试！");
			return map;
		}
		moviessayArticle.setArticleLike(articleLike+moviessayArticle.getArticleLike());
		int rs = this.moviessayArticleMapper.updateByPrimaryKeySelective(moviessayArticle);
		if(rs > 0){
			map.put("status", "ok");
			map.put("msg", "刷票成功！");
			return map;
		}
		map.put("status", "error");
		map.put("msg", "刷票失败！");
		return map;
	}
}
