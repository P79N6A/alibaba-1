package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.dao.CmsApiMapper;
import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.webservice.api.service.CmsApiService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Service
public class CmsApiServiceImpl implements CmsApiService {

	@Autowired
	private CmsApiMapper cmsApiMapper;
	
	@Autowired
	private SysDictMapper sysDictMapper;
	
	@Override
	public String queryVenueBySysId(String sysId,String sysNo) {
		Map map=new HashMap();
		map.put("sysId", sysId);
		map.put("sysNo", sysNo);
		List<String> list=cmsApiMapper.queryVenueBySysId(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
		
	}

	@Override
	public String queryActivitRoomyBySysId(String sysId,String sysNo) {
		Map map=new HashMap();
		map.put("sysId", sysId);
		map.put("sysNo", sysNo);
		List<String> list=cmsApiMapper.queryActivitRoomyBySysId(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@Override
	public String queryAntiqueBySysId(String sysId,String sysNo) {
		Map map=new HashMap();
		map.put("sysId", sysId);
		map.put("sysNo", sysNo);
		List<String> list=cmsApiMapper.queryAntiqueBySysId(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@Override
	public String queryActivityBySysId(String sysId,String sysNo) {
		Map map=new HashMap();
		map.put("sysId", sysId);
		map.put("sysNo", sysNo);
		List<String> list=cmsApiMapper.queryActivityBySysId(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}
	
	@Override
	public String queryTags(String tagsId,String dictCode) {
		StringBuffer rtnValue=new StringBuffer();
		List<String> tagsList=new ArrayList<String>();
		if(StringUtils.isNoneBlank(tagsId)){
			String[] arrTags=tagsId.split(",");
			for(int i=0;i<arrTags.length;i++){
				if(StringUtils.isNoneBlank(arrTags[i])){
					tagsList.add(arrTags[i]);
				}
			}
		}
		Map<String,Object> map=new HashMap();
		map.put("dictCode", dictCode);
		map.put("tagsId", tagsList);
		List<String> list=this.cmsApiMapper.queryTags(map);
		if(list.size()>0){
			for(int j=0;j<list.size();j++){
				rtnValue.append(list.get(j)).append(",");
			}
			return rtnValue.toString();
		}
		return null;
	}

	
	@Override
	public String getTag(String tagsId, String dictCode) {
		List<String> tagsList=new ArrayList<String>();
		
		Map<String,Object> map=new HashMap();
		map.put("dictCode", dictCode);
		map.put("tagsId", tagsId);
		
		//如果查询到的数据与输入标签的数据相等，则说明标签数据在数据库中是存在的
		List<String> list=this.cmsApiMapper.queryTag(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@Override
	public String getTags(String tagsId, String dictCode) {
		StringBuffer rtnValue=new StringBuffer();
		List<String> tagsList=new ArrayList<String>();
		//根据,解析tagId
		if(StringUtils.isNoneBlank(tagsId)){
			String[] arrTags=tagsId.split(",");
			for(int i=0;i<arrTags.length;i++){
				if(StringUtils.isNoneBlank(arrTags[i])){
					tagsList.add(arrTags[i]);
				}
			}
		}
		Map<String,Object> map=new HashMap();
		map.put("dictCode", dictCode);
		map.put("tagsId", tagsList);
		
		//如果查询到的数据与输入标签的数据相等，则说明标签数据在数据库中是存在的
		List<String> list=this.cmsApiMapper.queryTags(map);
		if(list.size()>0){
			for(int j=0;j<list.size();j++){
				rtnValue.append(list.get(j)).append(",");
			}
			return rtnValue.toString();
		}
		
		return null;
	}
	@Override
	public boolean checkTags(String tagsId, String dictCode) {
		
		List<String> tagsList=new ArrayList<String>();
		//根据,解析tagId
		if(StringUtils.isNoneBlank(tagsId)){
			String[] arrTags=tagsId.split(",");
			for(int i=0;i<arrTags.length;i++){
				if(StringUtils.isNoneBlank(arrTags[i])){
					tagsList.add(arrTags[i]);
				}
			}
		}
		Map<String,Object> map=new HashMap();
		map.put("dictCode", dictCode);
		map.put("tagsId", tagsList);
		
		//如果查询到的数据与输入标签的数据相等，则说明标签数据在数据库中是存在的
		List list=this.cmsApiMapper.queryTags(map);
		if(tagsList.size()==list.size()){
			return true;
		}
		
		return false;
	}

	@Override
	public String getAreaLocation(String dictCode, String dictName) {
		Map<String,Object> map=new HashMap();
		map.put("dictCode", dictCode);
		map.put("tagsId", dictName);
		List<String> list=this.cmsApiMapper.queryDict(map);
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}
	
	@Override
	public String checkSysDictByChildName(String dictCode,String dictName){

			Map<String, Object> map = new HashMap();
			map.put("dictCode", dictCode);
			map.put("dictName", dictName);
			List<String> list = this.cmsApiMapper.checkSysDictByChildName(map);
			if(list.size()>0){
				return list.get(0);
			}
			else 
				return null;
		}


	@Override
	public String getAPITags(String tagName,String dictName) {

		Map<String,Object> map=new HashMap();
		map.put("tagName", tagName);
		map.put("dictName",dictName);
		List<String> tagsIdAPI = this.cmsApiMapper.queryAPITags(map);
		if(tagsIdAPI.size()>0){
			return  tagsIdAPI.get(0);
		}

		return null;
	}
}
