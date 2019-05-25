package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;

public interface CcpVolunteerApplyMapper {

	List<CcpVolunteerApplyDto> selectByUserId(Map map);
}