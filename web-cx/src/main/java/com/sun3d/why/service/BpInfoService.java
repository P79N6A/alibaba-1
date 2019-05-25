package com.sun3d.why.service;
import java.util.List;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

public interface BpInfoService {

	List<BpInfo> queryCommendUnionPage(String member,Integer index);

	List<BpInfo> queryCommendUnion(String member,Integer count);

	List<BpInfo> queryInfoByMember(CmsMemberBO bo);

	/**
	 * 根据模块查询推荐人文洪山
	 * @param tag 模块
	 * @return
	 */
	List<BpInfo> queryRecommendInfo(String type);

	/**
	 * 根据模块查找人文洪山推荐列表
	 * @param tag
	 * @return
	 */
	List<BpInfo> queryRecommendListByTag(String tagCode);

	/**
	 * 资讯详情页资讯信息
	 * @param infoId
	 * @return
	 */
	BpInfo queryBpInfo(String infoId);

	/**
	 * 资讯详情页推荐列表
	 * @param infoId
	 * @return
	 */
	List<BpInfo> queryRecommendList(String infoId);

	/**
	 * 资讯详情页位置标签信息
	 * @param infoId
	 * @return
	 */
	BpInfo queryBpTagInfo(String infoId);

	/**
	 * 资讯列表页资讯列表
	 * @param infoTagCode
	 * @param page 
	 * @return
	 */
	List<BpInfo> queryInfoList(String infoTagCode,Pagination page);

	/**
	 * 咨询详情页点赞
	 * @param bpInfoId 资讯id
	 * @param userId 点赞用户id
	 */
	void addInfoUserWantgo(String bpInfoId, String userId);

	/**
	 * 资讯详情页取消点赞
	 * @param bpInfoId 资讯id
	 * @param userId 点赞用户id
	 */
	void delInfoUserWantgo(String bpInfoId, String userId);

	/**
	 * 资讯列表页（微信——无需查询总数，只需要查询当前页数据）
	 * @param infoTagCode 子标签code
	 * @param pageApp	分页数据
	 * @return
	 */
	List<BpInfo> wechatQueryInfoList(String infoTagCode, PaginationApp pageApp);

	/**
	 * 根据用户id，关联id查找是否点赞
	 * @param userId 	用户Id	
	 * @param infoId	关联Id
	 * @return
	 */
	Integer queryCountUserIsWant(String userId, String infoId);

	/**
	 * 根据关联Id 查找评论总量
	 * @param infoId
	 * @return
	 */
	Integer queryCmsCommentCount(String infoId);

	/**
	 * 根据关联Id 查找点赞总量
	 * @param infoId
	 * @return
	 */
	Integer queryWantgoCount(String infoId);

	List<BpInfo> pcnewInfo(int i);

}
