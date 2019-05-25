package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleMapper;
import com.sun3d.why.model.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.model.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.service.CcpMusicessayArticleService;
import com.sun3d.why.util.Pagination;
@Service
public class CcpMusicessayArticleServiceImpl implements CcpMusicessayArticleService {
	
	@Autowired
	private CcpMusicessayArticleMapper  musicessayArticleMapper;

	@Override
	public List<CcpMusicessayArticleDto> queryMusicessayArticle(CcpMoviessayArticleDto ccpMusicessayArticle, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(ccpMusicessayArticle.getArticleType() != null){
			map.put("articleType", ccpMusicessayArticle.getArticleType());
		}
		
		if(!StringUtils.isEmpty(ccpMusicessayArticle.getUserRealName())){
			map.put("userRealName", "%"+ccpMusicessayArticle.getUserRealName()+"%");
		}
		
		if(!StringUtils.isEmpty(ccpMusicessayArticle.getUserMoblieNo())){
			map.put("userMoblieNo", "%"+ccpMusicessayArticle.getUserMoblieNo()+"%");
		}
		
		if(ccpMusicessayArticle.getArticleIsDel() != null){
			map.put("articleIsDel", ccpMusicessayArticle.getArticleIsDel());
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = this.musicessayArticleMapper.queryMusicessayArticleCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		
		return this.musicessayArticleMapper.queryMusicessayArticleByList(map);
	}

	@Override
	public Map<String, Object> deletedMusicessayArticle(String articleId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isEmpty(articleId)){
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		CcpMusicessayArticle musicessayArticle = this.musicessayArticleMapper.selectByPrimaryKey(articleId);
		if(musicessayArticle == null){
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		
		if(musicessayArticle.getArticleIsDel()==0){
			musicessayArticle.setArticleIsDel(1);
		}else if(musicessayArticle.getArticleIsDel()==1){
			musicessayArticle.setArticleIsDel(0);
		}else{
			map.put("status", "error");
			map.put("msg", "审核异常，请稍候再试！");
			return map;
		}
		
		int rs = this.musicessayArticleMapper.updateByPrimaryKeySelective(musicessayArticle);
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
	public CcpMusicessayArticle queryMusicessayArticleById(String articleId) {
		return this.musicessayArticleMapper.selectByPrimaryKey(articleId);
	}

	@Override
	public CcpMusicessayArticle checkMessage(String articleId) {
		return this.musicessayArticleMapper.checkMessage(articleId);
	}

	@Override
	public Map<String, Object> updateVote(String articleId, Integer articleLike) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isEmpty(articleId)){
			map.put("status", "error");
			map.put("msg", "刷票异常，请稍候再试！");
			return map;
		}
		CcpMusicessayArticle musicessayArticle = this.musicessayArticleMapper.selectByPrimaryKey(articleId);
		if(musicessayArticle == null){
			map.put("status", "error");
			map.put("msg", "刷票异常，请稍候再试！");
			return map;
		}
		musicessayArticle.setArticleLike(articleLike+musicessayArticle.getArticleLike());
		int rs = this.musicessayArticleMapper.updateByPrimaryKeySelective(musicessayArticle);
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
