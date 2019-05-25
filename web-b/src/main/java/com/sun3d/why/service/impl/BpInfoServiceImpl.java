package com.sun3d.why.service.impl;

import com.sun3d.why.dao.BpInfoMapper;
import com.sun3d.why.dao.BpInfoTagMapper;
import com.sun3d.why.dao.SysDeptMapper;
import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class BpInfoServiceImpl implements BpInfoService {

	@Autowired
	private SysDeptMapper sysDeptMapper;

	@Autowired
	private BpInfoMapper bpInfoMapper;

	@Autowired
	private SysDictMapper sysDictMapper;

	@Autowired
	private BpInfoTagMapper bpInfoTagMapper;

	@Override
	public String findDeptNameById(String userDeptId) {
		SysDept sysDept = sysDeptMapper.querySysDeptByDeptId(userDeptId);
		return sysDept.getDeptName();
	}

	@Override
	public String addInfo(BpInfo bpInfo, SysUser sysUser) {
		int count;
		// 设置图片为空
		if (StringUtils.isBlank(bpInfo.getBeipiaoinfoImages())) {
			bpInfo.setBeipiaoinfoImages("");
		}
		// 设置视频为空
		if (StringUtils.isBlank(bpInfo.getBeipiaoinfoVideo())) {
			bpInfo.setBeipiaoinfoVideo("");
		}
		bpInfo.setBeipiaoinfoUpdateTime(new Date());
		bpInfo.setBeipiaoinfoUpdateUser(sysUser.getUserId());
		if (StringUtils.isBlank(bpInfo.getBeipiaoinfoId())) {
			// 状态设置为"0"，表示未上架
			bpInfo.setBeipiaoinfoStatus("0");
			// number设置为"0"，表示未推荐
			bpInfo.setBeipiaoinfoNumber("0");
			bpInfo.setBeipiaoinfoId(UUIDUtils.createUUId());
			bpInfo.setBeipiaoinfoCreateUser(sysUser.getUserId());
			bpInfo.setBeipiaoinfoCreateTime(new Date());
			count = bpInfoMapper.insert(bpInfo);
		} else {
			count = bpInfoMapper.updateByPrimaryKeySelective(bpInfo);
		}
		if (count > 0) {
			return Constant.RESULT_STR_SUCCESS;
		} else {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@Override
	public BpInfo queryAll() {

		BpInfo bpInfo = bpInfoMapper.selectByPrimaryKey("02fe1f70605d4029aff1b069144e7d27");
		return bpInfo;
	}

	@Override
	public List<BpInfo> queryInfoListByCondition(BpInfo bpInfo, Pagination page,String userDeptPath) {
		Map<String, Object> queryMap = new HashMap<>();
		queryMap.put("infoTitle", bpInfo.getBeipiaoinfoTitle());
		queryMap.put("infoTag", bpInfo.getBeipiaoinfoTag() == null ? null : "" + bpInfo.getBeipiaoinfoTag());
		queryMap.put("infoStatus", bpInfo.getBeipiaoinfoStatus());
		queryMap.put("infoType", bpInfo.getBeipiaoinfoShowtype());
		queryMap.put("userDeptPath", userDeptPath);
		if(StringUtils.isNotBlank(bpInfo.getModule())) {
			queryMap.put("module", bpInfo.getModule());
		}
		//queryMap.put("createUser", bpInfo.getBeipiaoinfoCreateUser());
		// 网页分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			// 查询出总数
			int total = bpInfoMapper.queryTotal(queryMap);
			queryMap.put("firstResult", page.getFirstResult());
			queryMap.put("rows", page.getRows());
			page.setTotal(total);
		}
		List<BpInfo> list = bpInfoMapper.queryListByMap(queryMap);
		return list;
	}

	@Override
	public void changInfoStatus(String infoId, String infoStatus, SysUser loginuser) {
		BpInfo bpInfo = new BpInfo();
		bpInfo.setBeipiaoinfoId(infoId);
		bpInfo.setBeipiaoinfoUpdateUser(loginuser.getUserId());
		bpInfo.setBeipiaoinfoUpdateTime(new Date());
		if (infoStatus != null && infoStatus != "") {
			// "0"表示已添加未上架——上架操作
			if ("0".equals(infoStatus)) {
				bpInfo.setBeipiaoinfoStatus("1");
			}
			// "1"表示已上架——下架操作
			if ("1".equals(infoStatus)) {
				bpInfo.setBeipiaoinfoStatus("0");
				bpInfo.setBeipiaoinfoNumber("0");
			}
			bpInfoMapper.updateByPrimaryKeySelective(bpInfo);
		}

	}

	@Override
	public void delInfo(String infoId, SysUser loginuser) {
		BpInfo bpInfo = new BpInfo();
		if (infoId != null && infoId != "") {
			bpInfo.setBeipiaoinfoId(infoId);
			bpInfo.setBeipiaoinfoUpdateUser(loginuser.getUserId());
			bpInfo.setBeipiaoinfoUpdateTime(new Date());
			// "2"表示已删除
			bpInfo.setBeipiaoinfoStatus("2");
			bpInfo.setBeipiaoinfoNumber("0");
		}
		bpInfoMapper.updateByPrimaryKeySelective(bpInfo);
	}

	@Override
	public List<String> queryInfoNumber(String infoId) {
		// 可用运营位集合
		List<String> resultList = new ArrayList<>();
		// 已被占用的运营位集合
		List<String> numberList = new ArrayList<>();
		// 父标签运营位数量集合
		List<String> tagList = new ArrayList<>();
		if (infoId != null && infoId != "") {
			BpInfoTag parentTag = bpInfoTagMapper.queryParentTagByInfoId(infoId);
			for (int i = 1; i <= parentTag.getTagAmount(); i++) {
				tagList.add(String.valueOf(i));
			}
			numberList = bpInfoMapper.queryNumberByTag(parentTag.getTagId());
			for (String string : tagList) {
				if (!numberList.contains(string)) {
					resultList.add(string);
				}
			}
		}
		return resultList;
	}

	@Override
	public void recommendInfo(String infoId, String infoNumber, SysUser loginuser) {
		BpInfo bpInfo = new BpInfo();
		bpInfo.setBeipiaoinfoUpdateUser(loginuser.getUserId());
		bpInfo.setBeipiaoinfoUpdateTime(new Date());
		if (infoId != null && infoId != "") {
			bpInfo.setBeipiaoinfoId(infoId);
		}
		if (infoNumber != null && infoNumber != "") {

			bpInfo.setBeipiaoinfoNumber(infoNumber);
		}
		bpInfo.setBeipiaoinfoStatus("1");
		bpInfoMapper.updateByPrimaryKeySelective(bpInfo);

	}

	@Override
	public void delRecommendInfo(String infoId, SysUser loginuser) {
		BpInfo bpInfo = new BpInfo();
		bpInfo.setBeipiaoinfoUpdateUser(loginuser.getUserId());
		bpInfo.setBeipiaoinfoUpdateTime(new Date());
		if (infoId != null && infoId != "") {
			bpInfo.setBeipiaoinfoId(infoId);
		}
		bpInfo.setBeipiaoinfoNumber("0");
		bpInfoMapper.updateByPrimaryKeySelective(bpInfo);
	}

	@Override
	public BpInfo selectInfoById(String infoId) {
		BpInfo bpInfo = null;
		if (infoId != null && infoId != "") {
			bpInfo = bpInfoMapper.selectByPrimaryKey(infoId);
		}
		return bpInfo;
	}

	@Override
	public List<SysDict> queryChildTagByInfoTag(String tagId) {
		List<SysDict> dictList = null;
		SysDict sysDict = new SysDict();
		if (tagId != null && tagId != "") {
			sysDict.setDictParentId(tagId);
			dictList = sysDictMapper.querySysDictByByCondition(sysDict);
		}
		return dictList;
	}

	@Override
	public List<SysDict> queryByCode(String parentCode) {
		List<SysDict> firstLevelDictLevel = null;
		if (parentCode != "" && parentCode != null) {
			// 根据父节点编码查找出其子节点集合
			firstLevelDictLevel = sysDictMapper.querySysDictByParentCode(parentCode);
		}
		return firstLevelDictLevel;
	}

}
