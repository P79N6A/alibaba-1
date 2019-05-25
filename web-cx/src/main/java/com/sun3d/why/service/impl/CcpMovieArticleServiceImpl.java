package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.culturecloud.model.bean.moviessay.CcpMoviessayLike;
import com.sun3d.why.dao.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.dao.ccp.CcpMoviessayArticleMapper;
import com.sun3d.why.dao.ccp.CcpMoviessayLikeMapper;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpMoviessayArticleService;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
@Service
public class CcpMovieArticleServiceImpl implements CcpMoviessayArticleService {
	
	@Autowired
	private CcpMoviessayArticleMapper ccpMoviessayArticleMapper;
	@Autowired
	private CcpMoviessayLikeMapper ccpMoviessayLikeMapper;
	@Autowired
	private StaticServer staticServer;
	
	@Override
	public List<CcpMoviessayArticleDto> queryMoviessayArticle(CcpMoviessayArticle moviessayArticle, String loginUser,
			PaginationApp page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(loginUser)) {
			map.put("loginUser", loginUser);
		}
		Integer articleType = moviessayArticle.getArticleType();
		Integer themeType = moviessayArticle.getThemeType();
		if(themeType != null){
			map.put("themeType", themeType);
		}
		if (articleType != null) {
			map.put("articleType", articleType);
		}
		String userId = moviessayArticle.getUserId();
		if (StringUtils.isNotBlank(userId)) {
			map.put("userId", userId);
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
			page.setTotal(total);
		}
		return ccpMoviessayArticleMapper.queryMoviessayArticleList(map);
	}

	
	
	
	@Override
	public int queryMoviessayArticleCount(CcpMoviessayArticle moviessayArticle) {
		Map<String, Object> map = new HashMap<String, Object>();
		String userId = moviessayArticle.getUserId();
		if (StringUtils.isNotBlank(userId)) {
			map.put("userId", userId);
		}
		String movieName = moviessayArticle.getMovieName();
		if(StringUtils.isNotBlank(movieName)){
			map.put("movieName", movieName);
		}else{
			return -1;
		}
		
		Integer articleType = moviessayArticle.getArticleType();
		if (articleType != null) {
			map.put("articleType", articleType);
		}
		return ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
	}

	@Override
	public int saveMoviessayArticle(CcpMoviessayArticle moviessayArticle) {
			String articleId = moviessayArticle.getArticleId();
			if (StringUtils.isBlank(articleId)) {
				moviessayArticle.setArticleId(UUIDUtils.createUUId());
				moviessayArticle.setArticleIsDel(0);
				moviessayArticle.setArticleCreateTime(new Date());
				moviessayArticle.setArticleLike(0);
				int i = ccpMoviessayArticleMapper.insert(moviessayArticle);
				// 增加用户积分
				if (i > 0) {
					Integer articleType = moviessayArticle.getArticleType();
					if (articleType == 1) {
						Map<String, Object> map = new HashMap<String, Object>();
						map.put("userId", moviessayArticle.getUserId());
						map.put("articleType", '1');
						// 微评
						int count = ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
						if (count == 1) {
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralChange(500);
							userIntegralDetail.setChangeType(0);
							userIntegralDetail.setIntegralFrom("电影中的真善美，微评发布");
							userIntegralDetail.setIntegralType(IntegralTypeEnum.MOVIE_WP.getIndex());
							userIntegralDetail.setUserId(moviessayArticle.getUserId());
							userIntegralDetail.setUpdateType(1);
							HttpClientConnection.post(
									staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do",
									(JSONObject) JSON.toJSON(userIntegralDetail));
						}
					} else if (articleType == 2) {

						Map<String, Object> map = new HashMap<String, Object>();
						map.put("userId", moviessayArticle.getUserId());
						map.put("articleType", '2');
						map.put("themeType", moviessayArticle.getThemeType());
						// 征文
						int count = ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
						if (count < 4) {
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralChange(1000);
							userIntegralDetail.setChangeType(0);
							userIntegralDetail.setIntegralFrom("电影中的真善美，征文发布 征文id：" + moviessayArticle.getArticleId());
							userIntegralDetail.setIntegralType(IntegralTypeEnum.MOVIE_ZW.getIndex());
							userIntegralDetail.setUserId(moviessayArticle.getUserId());
							userIntegralDetail.setUpdateType(0);
							HttpClientConnection.post(
									staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do",
									(JSONObject) JSON.toJSON(userIntegralDetail));
						}
					}
				}
				return i;
			} else {
				return ccpMoviessayArticleMapper.updateByPrimaryKeySelective(moviessayArticle);
			}
	}

	
	

	/**
	 * 点击赞的操作
	 * param:String userId 
	 * param:String articleId
	 * @return
	 */
	@Override
	@Transactional(isolation = Isolation.REPEATABLE_READ)
	public int likeMoviessayArticle(String userId, String articleId) {
		try {
			CcpMoviessayLike like = new CcpMoviessayLike();
			like.setArticleId(articleId);
			like.setUserId(userId);
			like.setCreateDate(new Date());
			int i = ccpMoviessayLikeMapper.insert(like);
			if (i > 0) {
				CcpMoviessayArticle article = ccpMoviessayArticleMapper.selectByPrimaryKey(articleId);
				Integer count = article.getArticleLike();
				if (count != null)
					article.setArticleLike(count + 1);
				else
					article.setArticleLike(1);
				ccpMoviessayArticleMapper.updateByPrimaryKeySelective(article);
			}
			return i;
			}catch(Exception e){
				e.printStackTrace();
				return -1;
			}
	}
	
	
	
	
	//明细的查询
	@Override
	public CcpMoviessayArticleDto queryMoviessayArticleDetail(String loginUser, String articleId) {
		return ccpMoviessayArticleMapper.queryMoviessayArticleDetail(loginUser, articleId);
	}

	
	
	
	//所有人的排名
	@Override
	public List<CcpMoviessayArticleDto> queryMoviessayArticleRanking(String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(userId)) {
			map.put("userId", userId);
		}
		List<CcpMoviessayArticleDto> list = ccpMoviessayArticleMapper.queryMoviessayArticleRanking(map);
		return list;
	}

	
	
	
	
	//当前用户的最大点赞数
	@Override
	public CcpMoviessayArticleDto myMoviessayArticleBest(String userId) {
		return ccpMoviessayArticleMapper.myMoviessayArticleBest(userId);
	}



	//当前用户的已发征文数量
	@Override
	public String queryMoviessayTimes(String userId) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("articleType", "2");
		map.put("themeType", "1");
		int rows1 = ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
		map.put("themeType", "2");
		int rows2 = ccpMoviessayArticleMapper.queryMoviessayArticleListCount(map);
		
		
		if(rows1<3 && rows2<3){
			return "all";
		}else if(rows1<3 && rows2==3){
			//可以发主题一
			return "1";
		}else if(rows1==3 && rows2<3){
			//可以发主题二
			return "2";
		}else{
			return "no";
		}
	}
}
