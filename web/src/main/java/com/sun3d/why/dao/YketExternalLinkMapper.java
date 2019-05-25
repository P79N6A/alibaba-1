package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.bean.yket.YketExternalLink;


public interface YketExternalLinkMapper {
    int deleteByPrimaryKey(String id);

    int insert(YketExternalLink record);

    int insertSelective(YketExternalLink record);

    YketExternalLink selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(YketExternalLink record);

    int updateByPrimaryKey(YketExternalLink record);

	int countYketExternalLink(Map<String, Object> map);

	List<YketExternalLink> countYketExternalLinkList(Map<String, Object> map);

	List<YketExternalLink> queryExternalLinkList();
}