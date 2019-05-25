package com.sun3d.why.dao;

import com.sun3d.why.model.cnwd.CnwdEntryformCheck;

public interface CnwdEntryformCheckMapper {
    int deleteByPrimaryKey(String checkId);

    int insert(CnwdEntryformCheck record);

    int insertSelective(CnwdEntryformCheck record);

    CnwdEntryformCheck selectByPrimaryKey(String checkId);

    int updateByPrimaryKeySelective(CnwdEntryformCheck record);

    int updateByPrimaryKey(CnwdEntryformCheck record);

	CnwdEntryformCheck queryByEntryId(String entryId);
}