package com.sun3d.why.service.impl;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.DcSuggestionMapper;
import com.sun3d.why.model.DcSuggestion;
import com.sun3d.why.service.DcSuggestionService;
import com.sun3d.why.util.UUIDUtils;

@Service
public class DcSuggestionServiceImpl implements DcSuggestionService {

	@Autowired
	private DcSuggestionMapper dcSuggestionMapper;

	@Override
	public String createDcSuggestion(DcSuggestion suggestion) {

		int result = 0;

		try {

			suggestion.setSuggestionId(UUIDUtils.createUUId());
			suggestion.setCreateTime(new Date());

			result = dcSuggestionMapper.insertSelective(suggestion);

		} catch (Exception e) {
			return "error";
		}

		if (result > 0)

			return "success";
		else
			return "failed";
	}

}
