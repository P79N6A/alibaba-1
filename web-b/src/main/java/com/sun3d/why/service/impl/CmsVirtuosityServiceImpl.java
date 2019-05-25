package com.sun3d.why.service.impl;

import com.aliyuncs.exceptions.ClientException;
import com.culturecloud.utils.ali.video.AliOssVideo;
import com.sun3d.why.dao.CmsAntiqueMapper;
import com.sun3d.why.dao.CmsAntiqueTypeMapper;
import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVirtuosityService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Service
@Transactional
public class CmsVirtuosityServiceImpl implements CmsVirtuosityService {
	
	@Autowired
	private CmsAntiqueMapper antiqueMapper;
	
	@Autowired
	private SysDictMapper dictMapper;
	
	@Autowired
	private CmsAntiqueTypeMapper antiqueTypeMapper;

	@Override
	public List<CmsAntique> queryAntiqueByCondition(CmsAntique antique,
			Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(StringUtils.isNotBlank(antique.getAntiqueName())){
			map.put("antiqueName", "%"+antique.getAntiqueName()+"%");
		}
		
		if(StringUtils.isNotBlank(antique.getAntiqueTypeName())){
			map.put("antiqueTypeName", antique.getAntiqueTypeName());
		}
		
		if(StringUtils.isNotBlank(antique.getDictName())){
			map.put("dictName", antique.getDictName());
		}
		
		if(page != null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = antiqueMapper.queryAntiqueCount(map);
			page.setTotal(total);
		}
		
		List<CmsAntique> list = antiqueMapper.queryAntiqueByList(map);
		
		return list;
	}

	@Override
	public CmsAntique queryVirtuosityById(String antiqueId) {
		return antiqueMapper.queryCmsAntiqueById(antiqueId);
	}

	@Override
	public int deleteVirtuosity(CmsAntique antique, SysUser user) {
		antique.setAntiqueIsDel(2);
		antique.setAntiqueUpdateTime(new Date());
		antique.setAntiqueUpdateUser(user.getUserId());
		return antiqueMapper.editCmsAntique(antique);
	}

	@Override
	public int saveVirtuosity(CmsAntique antique, SysUser user) {
		CmsAntiqueType antiqueType = null;
		antique.setAntiqueId(UUIDUtils.createUUId());
		antique.setAntiqueCreateTime(new Date());
		antique.setAntiqueUpdateTime(new Date());
		antique.setAntiqueCreateUser(user.getUserId());
		antique.setAntiqueIsDel(1);
		antique.setAntiqueIsVoice(1);
		antique.setAntiqueState(6);
		antique.setAntiqueIs3d(1);
		
		if(!StringUtils.isEmpty(antique.getAntiqueVideoUrl())){
			int index=antique.getAntiqueVideoUrl().lastIndexOf("/");
			final String videoUrl=antique.getAntiqueVideoUrl().substring(0, index+1);
			final String videoName=antique.getAntiqueVideoUrl().substring(index+1, antique.getAntiqueVideoUrl().length());
			int index2=videoName.lastIndexOf(".");
			final String videoNewName=videoName.substring(0,index2);
			
			Runnable runnable = new Runnable() {
	            @Override
	            public void run() {
	            	try {
	            		AliOssVideo.transvideo("virtuosity", videoName, videoNewName+".mp4");
	    			} catch (ClientException e) {
	    				e.printStackTrace();
	    			}
	            }
	        };
	        Thread thread = new Thread(runnable);
	        thread.start();
	        
	        antique.setAntiqueVideoUrl(videoUrl+videoNewName+".mp4");
		}
        
		return antiqueMapper.addCmsAntique(antique);
	}

	@Override
	public int updateAntique(CmsAntique antique, SysUser user) {
		antique.setAntiqueId(antique.getAntiqueId());
		antique.setAntiqueUpdateTime(new Date());
		antique.setAntiqueUpdateUser(user.getUserId());
		
		if(!StringUtils.isEmpty(antique.getAntiqueVideoUrl())){
			int index=antique.getAntiqueVideoUrl().lastIndexOf("/");
			final String videoUrl=antique.getAntiqueVideoUrl().substring(0, index+1);
			final String videoName=antique.getAntiqueVideoUrl().substring(index+1, antique.getAntiqueVideoUrl().length());
			int index2=videoName.lastIndexOf(".");
			final String videoNewName=videoName.substring(0,index2);
			
			Runnable runnable = new Runnable() {
	            @Override
	            public void run() {
	            	try {
	            		AliOssVideo.transvideo("virtuosity", videoName, videoNewName+".mp4");
	    			} catch (ClientException e) {
	    				e.printStackTrace();
	    			}
	            }
	        };
	        Thread thread = new Thread(runnable);
	        thread.start();
	        
	        antique.setAntiqueVideoUrl(videoUrl+videoNewName+".mp4");
		}
		
		return antiqueMapper.editCmsAntique(antique);
	}

	@Override
	public CmsAntique queryAntiqueById(String antiqueId) {
		
		return antiqueMapper.queryAntiqueById(antiqueId);
	}
	

}
