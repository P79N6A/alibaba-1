package com.culturecloud.service.local.impl.association;

import java.util.Date;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.association.CcpAssociationFlowerMapper;
import com.culturecloud.model.bean.association.CcpAssociationFlower;
import com.culturecloud.service.local.association.CcpAssociationFlowerService;

@Service
public class CcpAssociationFlowerServiceImpl implements CcpAssociationFlowerService{
	
	@Resource
	private  CcpAssociationFlowerMapper  associationFlowerMapper;

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public int saveCcpAssociationFlower(CcpAssociationFlower associationFlower) {
		
		Integer count=associationFlowerMapper.countUserAssociationTodayFlower(associationFlower);
		
		if(count==0)
		{
			associationFlower.setCreateTime(new Date());
			
			int result=associationFlowerMapper.insert(associationFlower);
			
			return result;
		}
	
		return 0;
	}

	
}
