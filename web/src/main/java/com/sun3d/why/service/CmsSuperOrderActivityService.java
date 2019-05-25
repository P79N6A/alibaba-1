package com.sun3d.why.service;

import com.sun3d.why.util.PaginationApp;

public interface CmsSuperOrderActivityService {
    
	String getActivityList(PaginationApp pageApp,String searchKey,String userId);
	
	String getActivityOrderList(PaginationApp pageApp,String userId);
}