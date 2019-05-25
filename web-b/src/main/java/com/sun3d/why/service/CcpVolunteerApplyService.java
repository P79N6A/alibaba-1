package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;
import com.sun3d.why.util.Pagination;

public interface CcpVolunteerApplyService {

	 List<CcpVolunteerApplyDto> queryCcpVolunteerApply(CcpVolunteerApply volunteerApply, Pagination page);
}
