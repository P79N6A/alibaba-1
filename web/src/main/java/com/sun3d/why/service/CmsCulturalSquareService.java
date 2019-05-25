package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.dao.dto.CmsCulturalSquareDto;
import com.sun3d.why.util.PaginationApp;

public interface CmsCulturalSquareService {
    
	List<CmsCulturalSquareDto> getCultureSquareList(PaginationApp pageApp,String userId);
	
}