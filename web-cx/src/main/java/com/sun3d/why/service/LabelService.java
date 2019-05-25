package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.vo.yket.YketLabelVo;
import com.sun3d.why.util.Pagination;

public interface LabelService {

	int addLabel(YketLabel label,  SysUser sysUser);

	List<YketLabelVo> listLabel(String labelType, Pagination pagination, String labelName);

	int updateLabel(YketLabel label,  SysUser sysUser);

	int deleteLabel(String labelId,  SysUser sysUser);

	YketLabel getLabelById(String labelId);

	int saveLabel(String labelType, String labelName, SysUser sysUser);

	int queryByLabelName(String labelName, Integer integer);

	int update(String labelId, String labelName, SysUser sysUser);

	String moveUp(String labelId, Integer sort);

	String moveDown(String labelId, Integer sort);

	 
	
	List<YketLabel> listLabelJson(String labelType, Pagination pagination);

	List<YketLabel> typeList(Integer labelType);

 }
