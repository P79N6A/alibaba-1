package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.cnwd.CnwdEntryForm;
import com.sun3d.why.util.Pagination;


public interface CnwdEntryFormService {

	int addCnwdEntryForm(String userId);

	Map<String, Object> addCnwdEntryFormOne(CnwdEntryForm cnwdEntryForm,
			String entryId);

	Map<String, Object> addCnwdEntryFormTwo(CnwdEntryForm cnwdEntryForm,
			String entryId);

	CnwdEntryForm queryCnwdEntryFormById(String entryId);

	List<CnwdEntryForm> queryCnwdEntryformListByAdminCondition(
			CnwdEntryForm cnwdEntryform, Pagination page, SysUser sysUser);

	CnwdEntryForm selectByPrimaryKey(String entryId);

	int checkCnwdEntryform(CnwdEntryForm cnwdEntryform);

	CnwdEntryForm queryEntryFormBycreateUser(String userId);

	String sendMessage(CnwdEntryForm cnwdEntryForm);
	
	
	

}
