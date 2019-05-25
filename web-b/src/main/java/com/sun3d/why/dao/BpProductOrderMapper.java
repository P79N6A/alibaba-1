package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpProductOrder;

public interface BpProductOrderMapper {
    
    int insert(BpProductOrder record);

	List<BpProductOrder> queryOrderByProductId(Map<String, Object> map);

	int queryOrderCountByProductId(Map<String, Object> map);
	
	

}