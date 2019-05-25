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
import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.culturecloud.model.bean.musicessay.CcpMusicessayLike;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleMapper;
import com.sun3d.why.dao.ccp.CcpMusicessayLikeMapper;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpMusicessayArticleService;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

@Service
public class CcpMusicessayArticleServiceImpl implements CcpMusicessayArticleService {

	@Autowired
	private CcpMusicessayArticleMapper ccpMusicessayArticleMapper;
	@Autowired
	private CcpMusicessayLikeMapper ccpMusicessayLikeMapper;
	@Autowired
	private StaticServer staticServer;

	@Override
	public List<CcpMusicessayArticleDto> queryMusicessayArticle(CcpMusicessayArticle musicessayArticle,
			String loginUser, PaginationApp page) {

		Map<String, Object> map = new HashMap<String, Object>();

		if (StringUtils.isNotBlank(loginUser)) {

			map.put("loginUser", loginUser);
		}
		Integer articleType = musicessayArticle.getArticleType();

		if (articleType != null) {

			map.put("articleType", articleType);
		}

		String userId = musicessayArticle.getUserId();

		if (StringUtils.isNotBlank(userId)) {
			map.put("userId", userId);
		}

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpMusicessayArticleMapper.queryMusicessayArticleListCount(map);
			page.setTotal(total);
		}

		return ccpMusicessayArticleMapper.queryMusicessayArticleList(map);
	}

	@Override
	public int saveMusicessayArticle(CcpMusicessayArticle musicessayArticle) {

		try {

			String articleId = musicessayArticle.getArticleId();

			if (StringUtils.isBlank(articleId)) {

				musicessayArticle.setArticleId(UUIDUtils.createUUId());
				musicessayArticle.setArticleIsDel(0);
				musicessayArticle.setArticleCreateTime(new Date());
				musicessayArticle.setArticleLike(0);

				int i = ccpMusicessayArticleMapper.insert(musicessayArticle);

				if (i > 0) {

					Integer articleType = musicessayArticle.getArticleType();

					if (articleType == 1) {
						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
						userIntegralDetail.setIntegralChange(500);
						userIntegralDetail.setChangeType(0);
						userIntegralDetail.setIntegralFrom("音乐中的真善美，微评发布");
						userIntegralDetail.setIntegralType(IntegralTypeEnum.MUSIC_WP.getIndex());
						userIntegralDetail.setUserId(musicessayArticle.getUserId());
						userIntegralDetail.setUpdateType(1);
						HttpClientConnection.post(
								staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do",
								(JSONObject) JSON.toJSON(userIntegralDetail));
					} else if (articleType == 2) {

						UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
						userIntegralDetail.setIntegralChange(1000);
						userIntegralDetail.setChangeType(0);
						userIntegralDetail.setIntegralFrom("音乐中的真善美，征文发布 征文id：" + musicessayArticle.getArticleId());
						userIntegralDetail.setIntegralType(IntegralTypeEnum.MUSIC_ZW.getIndex());
						userIntegralDetail.setUserId(musicessayArticle.getUserId());
						userIntegralDetail.setUpdateType(0);
						HttpClientConnection.post(
								staticServer.getChinaServerUrl() + "chinaIntegral/updateIntegralByJson.do",
								(JSONObject) JSON.toJSON(userIntegralDetail));
					}

				}

				return i;
			} else {
				return ccpMusicessayArticleMapper.updateByPrimaryKeySelective(musicessayArticle);

			}
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}

	}

	@Override
	@Transactional(isolation = Isolation.REPEATABLE_READ)
	public int likeMusicessayArticle(String userId, String articleId) {

		try {

			CcpMusicessayLike like = new CcpMusicessayLike();
			like.setArticleId(articleId);
			like.setUserId(userId);
			like.setCreateDate(new Date());

			int i = ccpMusicessayLikeMapper.insert(like);

			if (i > 0) {

				CcpMusicessayArticle article = ccpMusicessayArticleMapper.selectByPrimaryKey(articleId);
				Integer count = article.getArticleLike();
				if (count != null)
					article.setArticleLike(count + 1);
				else
					article.setArticleLike(1);

				ccpMusicessayArticleMapper.updateByPrimaryKeySelective(article);

			}

			return i;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}

	}

	@Override
	public CcpMusicessayArticleDto queryMusicessayArticleDetail(String loginUser, String articleId) {

		return ccpMusicessayArticleMapper.queryMusicessayArticleDetail(loginUser, articleId);
	}

	@Override
	public int queryMusicessayArticleCount(CcpMusicessayArticle musicessayArticle) {

		Map<String, Object> map = new HashMap<String, Object>();

		String userId = musicessayArticle.getUserId();

		if (StringUtils.isNotBlank(userId)) {

			map.put("userId", userId);
		}
		Integer articleType = musicessayArticle.getArticleType();

		if (articleType != null) {

			map.put("articleType", articleType);
		}

		return ccpMusicessayArticleMapper.queryMusicessayArticleListCount(map);
	}

	@Override
	public List<CcpMusicessayArticleDto> queryMusicessayArticleRanking(String userId) {


		Map<String, Object> map = new HashMap<String, Object>();

		if (StringUtils.isNotBlank(userId)) {

			map.put("userId", userId);
		}
		
		List<CcpMusicessayArticleDto> list = ccpMusicessayArticleMapper.queryMusicessayArticleRanking(map);
		
		return list;
	}

	@Override
	public CcpMusicessayArticleDto myMusicessayArticleBest(String userId) {
		
		return ccpMusicessayArticleMapper.myMusicessayArticleBest(userId);
	}

}
