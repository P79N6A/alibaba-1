package com.sun3d.why.dao.dto;

import java.util.List;

import com.culturecloud.model.bean.culture.CcpCultureContestOption;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;

public class CcpCultureContestQuestionDto extends CcpCultureContestQuestion{

	private List<CcpCultureContestOption> optionList;

	public List<CcpCultureContestOption> getOptionList() {
		return optionList;
	}

	public void setOptionList(List<CcpCultureContestOption> optionList) {
		this.optionList = optionList;
	}
	
	
}
