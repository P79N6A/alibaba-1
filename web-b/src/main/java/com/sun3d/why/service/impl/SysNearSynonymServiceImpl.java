package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.common.SysNearSynonym;
import com.sun3d.why.dao.SysNearSynonymMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysNearSynonymService;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class SysNearSynonymServiceImpl implements SysNearSynonymService {
	
	@Autowired
	private SysNearSynonymMapper sysNearSynonymMapper;

	/* (non-Javadoc)
	 * @see com.sun3d.why.service.SysNearSynonymService#importSysNearSynonym(java.util.List)
	 */
	@Override
	public List<String> importSysNearSynonym(SysUser sysUser,List<List<String>> dataList) {
		
		// 一对多数据结构
		LinkedHashMap<String,TreeSet<String>> map=new LinkedHashMap<String,TreeSet<String>>();
		
		// 检查名称重复集合
		Set<String> nameCheckSet=new HashSet<String>();
		
		// 错误信息集合
		List<String>errorInfo=new ArrayList<String>();
		
		 String nearSynonym="";

		 for (int i = 0; i < dataList.size(); i++) {
			 
			 List<String> list =dataList.get(i);
			 
			 String word="";
			 
			 int line=0;
			 
			 for (int j = 0; j < list.size(); j++) {
				 
				 String text=list.get(j).trim();
				 
				 switch (j) {
				case 0:
					word=text;
					break;
				case 1:
					if(StringUtils.isNotBlank(text))
						nearSynonym=text;
					break;
				case 2:
					line=Integer.valueOf(text);
					break;
				}
			}
			
			if(StringUtils.isNotBlank(word)||StringUtils.isNotBlank(nearSynonym)){
				
				if(nameCheckSet.contains(word))
				{
					String error="第"+line+"行关键词'"+word+"'重复！";
					errorInfo.add(error);
					continue;
				}
//				else if(nameCheckSet.contains(nearSynonym)){
//					
//					String error="第"+line+"行所属近义词'"+word+"'重复！";
//					errorInfo.add(error);
//					continue;
//				}
				else
				{
					nameCheckSet.add(word);
					nameCheckSet.add(nearSynonym);
					
					if(map.containsKey(nearSynonym)){
						
						TreeSet<String> wordSet=map.get(nearSynonym);
						wordSet.add(word);
						map.put(nearSynonym, wordSet);
					}
					else
					{
						TreeSet<String> wordSet=new TreeSet<>();
						wordSet.add(word);
						map.put(nearSynonym, wordSet);
					}
				}
				
			}
		}
		if(errorInfo.size()>0)
			return errorInfo;
		
		int count=sysNearSynonymMapper.deleteAll();
		
		for (Map.Entry<String,TreeSet<String>> entry : map.entrySet()) {
			
			SysNearSynonym sysNearSynonym=new SysNearSynonym();
			
			String parentId=UUIDUtils.createUUId();
			
			sysNearSynonym.setSynonymName(entry.getKey());
			sysNearSynonym.setCreateUser(sysUser.getUserId());
			sysNearSynonym.setCreateTime(new Date());
			sysNearSynonym.setSynonymId(parentId);
			
			sysNearSynonymMapper.insert(sysNearSynonym);
			
			if(count>0)
			for (String word : entry.getValue()) {
				
				sysNearSynonym=new SysNearSynonym();
				
				sysNearSynonym.setSynonymName(word);
				sysNearSynonym.setCreateUser(sysUser.getUserId());
				sysNearSynonym.setCreateTime(new Date());
				sysNearSynonym.setSynonymId(UUIDUtils.createUUId());
				sysNearSynonym.setParentSynonymId(parentId);
				
				sysNearSynonymMapper.insert(sysNearSynonym);
			}
		}
		
		
		return errorInfo;
	}

}
