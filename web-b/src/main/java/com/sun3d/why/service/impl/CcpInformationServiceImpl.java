package com.sun3d.why.service.impl;

import com.aliyuncs.exceptions.ClientException;
import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.utils.ali.video.AliOssVideo;
import com.sun3d.why.dao.CcpInformationMapper;
import com.sun3d.why.dao.dto.CcpInformationDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpInformationService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CcpInformationServiceImpl implements CcpInformationService{
	
	@Autowired
	private CcpInformationMapper ccpInformationMapper;

	@Override
	public List<CcpInformationDto> informationList(CcpInformation information, Pagination page, SysUser sysUser) {
		Map<String, Object> map = new HashMap<>();

		String informationTitle=information.getInformationTitle();
		if(StringUtils.isNotBlank(informationTitle)){
			map.put("informationTitle", informationTitle);
		}

		// 资讯模块ID
		if(StringUtils.isNotBlank(information.getInformationModuleId())){
			map.put("informationModuleId", information.getInformationModuleId());
		}

		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total =ccpInformationMapper.queryInformationByConditionCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		List<CcpInformationDto>  list=	ccpInformationMapper.queryInformationByCondition(map);
		
		return list;
	}

	@Override
	public int addInformation(CcpInformation information) {
		
		String informationVideoUrl=information.getVideoUrl();
		
		if(StringUtils.isNotBlank(informationVideoUrl)){
			
			final String videoNewName= AliOssVideo.getVideoNewName(informationVideoUrl);
			
			int index=informationVideoUrl.lastIndexOf("/");
			final String videoUrl=informationVideoUrl.substring(0, index+1);
			final String videoName=informationVideoUrl.substring(index+1, informationVideoUrl.length());
			
			 //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                	
                	try {
                		AliOssVideo.transvideo("video", videoName, videoNewName);
        			} catch (ClientException e) {
        				e.printStackTrace();
        			}
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
			
            information.setVideoUrl(videoUrl+videoNewName);
		}

		
		
		return ccpInformationMapper.insert(information);
	}

	@Override
	public int updateInformation(CcpInformation information) {
		
	String informationVideoUrl=information.getVideoUrl();
		
		if(StringUtils.isNotBlank(informationVideoUrl)){
			
			final String videoNewName= AliOssVideo.getVideoNewName(informationVideoUrl);
			
			int index=informationVideoUrl.lastIndexOf("/");
			final String videoUrl=informationVideoUrl.substring(0, index+1);
			final String videoName=informationVideoUrl.substring(index+1, informationVideoUrl.length());
			
			 //删除缓存
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                	
                	try {
                		AliOssVideo.transvideo("video", videoName, videoNewName);
        			} catch (ClientException e) {
        				e.printStackTrace();
        			}
                }
            };
            Thread thread = new Thread(runnable);
            thread.start();
			
            information.setVideoUrl(videoUrl+videoNewName);
		}

		
		return ccpInformationMapper.updateByPrimaryKeySelective(information);
	}

	@Override
	public CcpInformation getInformation(String informationId) {
		return ccpInformationMapper.selectByPrimaryKey(informationId);
	}

}
