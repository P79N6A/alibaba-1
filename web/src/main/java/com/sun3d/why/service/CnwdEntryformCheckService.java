package com.sun3d.why.service;

import com.sun3d.why.model.cnwd.CnwdEntryformCheck;

public interface CnwdEntryformCheckService {

	CnwdEntryformCheck queryEntryformCheckById(String entryId);

	void insert(CnwdEntryformCheck cnwdEntryformCheck1);

	void update(CnwdEntryformCheck cnwdEntryformCheck);


}
