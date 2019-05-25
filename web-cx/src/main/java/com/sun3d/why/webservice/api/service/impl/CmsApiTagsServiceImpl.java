/*
@author lijing
@version 1.0 2015年8月4日 下午8:11:03
*/
package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.service.CmsTagService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.service.CmsApiTagsService;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CmsApiTagsServiceImpl implements CmsApiTagsService {

	@Autowired
	private SysDictService sysDictService;
	@Autowired
	private CmsTagService cmsTagService;

	// 判断标签，比如场馆类型标签与id判断传过来的标签是否存在
	public boolean checkTags(String tagsId, String dictCode) throws Exception {
		
		CmsTag  tag=this.cmsTagService.queryCmsTagByTagId(tagsId);
		if(tag!=null){
			SysDict dict = new SysDict();
			dict.setDictState(Constant.NORMAL);
			dict.setDictCode(dictCode);

			List<SysDict> dicts = this.sysDictService.querySysDictByByCondition(dict);
			if (dicts != null && dicts.size() > 0) {

				List list = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
				if (list.size() > 0) {
					return true;
				}
			}
		}
	
		return false;
	}

	// 判断指定区是否存在
	public boolean checkDictArea(String venueArea) throws Exception {
		if (StringUtils.isNotNull(venueArea)) {
			String dictCode = venueArea.indexOf(',') > 0 ? venueArea.substring(0, venueArea.indexOf(','))
					: venueArea;
			SysDict dict = new SysDict();
			dict.setDictState(Constant.NORMAL);
			dict.setDictCode(dictCode);
			List<SysDict> dicts = this.sysDictService.querySysDictByByCondition(dict);
			if (dicts.size() > 0) {
				return true;
			}
		}
		return false;
	}

	// 判断位置指定区域的位置数据是否存在
	public boolean checkDictMood(String dictId, String parentDictCode) throws Exception {
		SysDict dict = new SysDict();
		dict.setDictState(Constant.NORMAL);
		dict.setDictCode(parentDictCode);

		List<SysDict> dictList = sysDictService.querySysDictByByCondition(dict);
		if (CollectionUtils.isNotEmpty(dictList)) {
			SysDict sysDict = dictList.get(0);
			dict.setDictCode(null);
			dict.setDictParentId(sysDict.getDictId());
			dict.setDictId(dictId);
			List list = sysDictService.querySysDictByByCondition(dict);
			if (list.size() > 0) {
				return true;
			}
		}
		return false;
	}

	@Override
	public List getChildTagByType(String code) {
		List<CmsTag> list = new ArrayList<CmsTag>();
		List<SysDict> dicts = sysDictService.querySysDictByCode(code);
		if (dicts != null && dicts.size() > 0) {
			list = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
		}
		return list;
	}

	@Override
	public List getChildDictByCode(String dictCode) {
		List<SysDict> sysDictList = new ArrayList<SysDict>();
		SysDict dict = new SysDict();
		dict.setDictState(Constant.NORMAL);
		dict.setDictCode(dictCode);
		List<SysDict> dictList = sysDictService.querySysDictByByCondition(dict);
		if(CollectionUtils.isNotEmpty(dictList)){
			SysDict sysDict = dictList.get(0);
			dict.setDictCode(null);
			dict.setDictParentId(sysDict.getDictId());
			sysDictList = sysDictService.querySysDictByByCondition(dict);
		}
		return sysDictList;
	}

}
