package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.dao.dto.QygProjectEntryDto;
import com.sun3d.why.model.qyg.QygProjectEntry;
import com.sun3d.why.model.qyg.QygUser;

public interface QygProjectEntryService {

	List<QygProjectEntryDto> queryEntryList(QygProjectEntryDto entry);

	QygProjectEntryDto queryUserById(String entryId);

	int saveQygUser(QygUser user);

}
