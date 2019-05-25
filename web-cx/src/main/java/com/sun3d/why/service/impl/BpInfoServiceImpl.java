package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sun3d.why.model.league.CmsMemberBO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.BpInfoMapper;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class BpInfoServiceImpl implements BpInfoService {

	@Autowired
	private BpInfoMapper bpInfoMapper;
	
	@Autowired
	private CmsUserWantgoMapper cmsUserWantgoMapper;
	
	@Autowired
	private CmsCommentMapper cmsCommentMapper;

	@Override
	public List<BpInfo> queryInfoByMember(CmsMemberBO bo){
		List<BpInfo> list =   bpInfoMapper.queryInfoByMember(bo);
		bo.setShowPage(false);
		bo.setTotal(bpInfoMapper.queryInfoByMember(bo).size());
		return list;
	}

	
	/**
	 * 根据模块查找人文洪山推荐列表
	 * @param
	 * @return
	 */
	@Override
	public List<BpInfo> queryRecommendListByTag(String tagCode) {
		List<BpInfo> list = new ArrayList<>();
		Map<String, Object> queryMap = new HashMap<>();
		queryMap.put("tagCode", tagCode);
		if ("jinribeipiao".equals(tagCode)) {
			queryMap.put("isShowPage", true);
		}		
		list = bpInfoMapper.queryBpInfoRecommendListByTag(queryMap);
		return list;
	}

	/**
	 * 资讯详情页资讯信息
	 * @param infoId 资讯id
	 * @return
	 */
	@Override
	public BpInfo queryBpInfo(String infoId) {
		return bpInfoMapper.queryBpInfoById(infoId);
	}

	@Override
	public List<BpInfo> queryRecommendList(String infoId) {
		return bpInfoMapper.queryRecommendListByInfoId(infoId);
	}

	@Override
	public BpInfo queryBpTagInfo(String infoId) {
		return bpInfoMapper.queryBpTagInfoByInfoId(infoId);
	}

	@Override
	public List<BpInfo> queryInfoList(String infoTagCode, Pagination page) {
		Map<String, Object> queryMap = new HashMap<>();
		queryMap.put("infoTagCode", infoTagCode);
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			// 查询出总数
			int total = bpInfoMapper.queryTotal(infoTagCode);
			queryMap.put("firstResult", page.getFirstResult());
			queryMap.put("rows", page.getRows());
			page.setTotal(total);
		}
		List<BpInfo> list = bpInfoMapper.queryBpInfoListByCode(queryMap);

		return list;
	}
	
	@Override
	public List<BpInfo> queryRecommendInfo(String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<BpInfo> list = new ArrayList<BpInfo>();
		if (StringUtils.isNotBlank(type)) {
			map.put("advertType", type);
		}
		list = bpInfoMapper.queryCommendByType(map);
		return list;
	}

	/**
	 * 咨询详情页点赞
	 * @param bpInfoId 资讯id
	 * @param userId 点赞用户id
	 */
	@Override
	public void addInfoUserWantgo(String bpInfoId, String userId) {
		CmsUserWantgo userWantgo = new CmsUserWantgo();
		if (bpInfoId != null && StringUtils.isNotBlank(bpInfoId)) {
			userWantgo.setRelateId(bpInfoId);
		}
		if (userId != null && StringUtils.isNotBlank(userId)) {
			userWantgo.setUserId(userId);
		}
		userWantgo.setSid(UUIDUtils.createUUId());
		userWantgo.setCreateTime(new Date());
		userWantgo.setRelateType(Constant.WANT_GO_BEIPIAOINFO);
		cmsUserWantgoMapper.addUserWantgo(userWantgo);
	}

	/**
	 * 资讯详情页取消点赞
	 * @param bpInfoId 资讯id
	 * @param userId 点赞用户id
	 */
	@Override
	public void delInfoUserWantgo(String bpInfoId, String userId) {
		CmsUserWantgo userWantgo = new CmsUserWantgo();
		if (bpInfoId != null && StringUtils.isNotBlank(bpInfoId)) {
			userWantgo.setRelateId(bpInfoId);
		}
		if (userId != null && StringUtils.isNotBlank(userId)) {
			userWantgo.setUserId(userId);
		}
        cmsUserWantgoMapper.deleteUserWantgo(userWantgo);
	}

	/**
	 * 资讯列表页（微信——无需查询总数，只需要查询当前页数据）
	 * @param infoTagCode 子标签code
	 * @param page	分页数据
	 * @return
	 */
	@Override
	public List<BpInfo> wechatQueryInfoList(String infoTagCode, PaginationApp page) {
		Map<String, Object> queryMap = new HashMap<>();
		if (infoTagCode!=null&&StringUtils.isNotBlank(infoTagCode)) {
			queryMap.put("infoTagCode", infoTagCode);
		}
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			// 查询出总数
			queryMap.put("firstResult", page.getFirstResult());
			queryMap.put("rows", page.getRows());
		}
		List<BpInfo> list = bpInfoMapper.queryBpInfoListByCode(queryMap);
		return list;
	}

	/**
	 * 根据用户id，关联id查找是否点赞
	 * @param userId 	用户Id	
	 * @param infoId	关联Id
	 * @return
	 */
	@Override
	public Integer queryCountUserIsWant(String userId, String relateId) {
		Map<String, Object> queryMap = new HashMap<>();
		if (userId!=null&&StringUtils.isNotBlank(userId)){
			queryMap.put("userId", userId);
		}
		if (relateId!=null&&StringUtils.isNotBlank(relateId)) {
			queryMap.put("relateId", relateId);
		}
		return cmsUserWantgoMapper.countUserWantgo(queryMap);
	}

	/**
	 * 根据关联Id 查找评论总量
	 * @param infoId
	 * @return
	 */
	@Override
	public Integer queryCmsCommentCount(String infoId) {
		Map<String, Object> queryMap = new HashMap<>();
		if (infoId!=null&&StringUtils.isNotBlank(infoId)) {
			queryMap.put("commentRkId", infoId);
		}
		queryMap.put("commentType", 20);
		
		return cmsCommentMapper.queryCmsCommentCount(queryMap);
	}

	/**
	 * 根据关联Id 查找点赞总量
	 * @param infoId
	 * @return
	 */
	@Override
	public Integer queryWantgoCount(String infoId) {
		Map<String, Object> queryMap = new HashMap<>();
		if (infoId!=null&&StringUtils.isNotBlank(infoId)) {
			queryMap.put("relateId", infoId);
		}
		return cmsUserWantgoMapper.queryUserWantgoCount(queryMap);
	}

	@Override
	public List<BpInfo> pcnewInfo(int num) {
		// TODO Auto-generated method stub
		Map map = new HashMap();
		map.put("orderBy", "BI.BEIPIAOINFO_CREATE_TIME DESC");
		map.put("firstResult", 0);
		map.put("rows", num);
		return bpInfoMapper.pcnewInfo(map);
	}

	@Override
	public List<BpInfo> queryCommendUnionPage(String member, Integer index) {
		return bpInfoMapper.queryCommendUnionPage( member,index);
	}

	@Override
	public List<BpInfo> queryCommendUnion(String member, Integer count) {
		return bpInfoMapper.queryCommendUnion( member, count);
	}
}
