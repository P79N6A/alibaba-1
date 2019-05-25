package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.vo.yket.YketLabelVo;

public interface YketLabelMapper {
	int deleteByPrimaryKey(String labelId);

	int insert(YketLabel record);

	int insertSelective(YketLabel record);

	YketLabel selectByPrimaryKey(String labelId);

	int updateByPrimaryKeySelective(YketLabel record);

	int updateByPrimaryKey(YketLabel record);

	List<YketLabelVo> listLable(Map<String, Object> conds);

	Integer count(Map<String, Object> conds);

	int queryByLabelName(Map<String, Object> map);

	List<YketLabel> moveUp(Map<String, Object> map);

	List<YketLabel> moveDown(Map<String, Object> map);
	
	List<YketLabel> listLableForJson(Map<String, Object> conds);

	List<YketLabel> typeList(Integer labelType);

}