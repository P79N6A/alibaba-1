package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.cnwd.CnwdEntryForm;


public interface CnwdEntryFormMapper {
    int deleteByPrimaryKey(String entryId);

    int insert(CnwdEntryForm record);

    int insertSelective(CnwdEntryForm record);

    CnwdEntryForm selectByPrimaryKey(String entryId);

    int updateByPrimaryKeySelective(CnwdEntryForm record);

    int updateByPrimaryKeyWithBLOBs(CnwdEntryForm record);

    int updateByPrimaryKey(CnwdEntryForm record);
    //后台
    int queryCnwdEntryformCountByCondition(Map<String, Object> map);

	List<CnwdEntryForm> queryCnwdEntryformListByCondition(
			Map<String, Object> map);

	CnwdEntryForm queryEntryFormBycreateUser(CnwdEntryForm cnwdEntryForm);
}