package com.sun3d.why.dao;

import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.league.CmsMemberBO;

import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

public interface BpInfoMapper {

	@Select("SELECT b.BEIPIAOINFO_ID beipiaoinfoId,b.BEIPIAOINFO_TITLE beipiaoinfoTitle,b.BEIPIAOINFO_HOMEPAGE beipiaoinfoHomepage,b.BEIPIAOINFO_CONTENT  beipiaoinfoContent from cms_member_relation r join bp_info b on r.relation_id=b.BEIPIAOINFO_ID and r.relation_type=2 WHERE r.member_id=#{0} and b.BEIPIAOINFO_STATUS=1 limit #{1}")
	List<BpInfo> queryCommendUnion(String member,Integer count);

	@Select("SELECT b.BEIPIAOINFO_ID beipiaoinfoId,b.BEIPIAOINFO_TITLE beipiaoinfoTitle,b.BEIPIAOINFO_HOMEPAGE beipiaoinfoHomepage,b.BEIPIAOINFO_CONTENT  beipiaoinfoContent from cms_member_relation r join bp_info b on r.relation_id=b.BEIPIAOINFO_ID and r.relation_type=2 WHERE r.member_id=#{0} and b.BEIPIAOINFO_STATUS=1 limit #{1},6")
	List<BpInfo> queryCommendUnionPage(String member,Integer index);

	List<BpInfo> queryInfoByMember(CmsMemberBO bo);

	List<BpInfo> queryCommendByTag(Map<String, Object> map);

	/**
	 * 根据便签code查找推荐资讯列表
	 * @param queryMap
	 * @return
	 */
	List<BpInfo> queryBpInfoRecommendListByTag(Map<String, Object> queryMap);

	BpInfo queryBpInfoById(String infoId);

	/**
	 * 根据资讯ID查找父标签下推荐列表
	 * @param infoId
	 * @return
	 */
	List<BpInfo> queryRecommendListByInfoId(String infoId);

	/**
	 * 根据资讯ID查找该资讯父子标签信息
	 * @param infoId
	 * @return
	 */
	BpInfo queryBpTagInfoByInfoId(String infoId);

	/**
	 * 根据标子签编码查找资讯列表
	 * @param queryMap（子标签编码+分页信息）
	 * @return
	 */
	List<BpInfo> queryBpInfoListByCode(Map<String, Object> queryMap);

	/**
	 * 查询数据总量
	 * @param infoTagCode
	 * @return
	 */
	int queryTotal(String infoTagCode);

	/**
	 * 首页推荐位
	 * @param map
	 * @return
	 */
	List<BpInfo> queryCommendByType(Map<String, Object> map);

	List<BpInfo> pcnewInfo(Map map);


}
