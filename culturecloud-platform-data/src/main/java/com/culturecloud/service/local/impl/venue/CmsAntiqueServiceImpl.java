package com.culturecloud.service.local.impl.venue;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.venue.CmsAntiqueMapper;
import com.culturecloud.model.bean.venue.CmsAntique;
import com.culturecloud.service.local.venue.CmsAntiqueService;
import com.culturecloud.utils.UUIDUtils;

@Service
@Transactional
public class CmsAntiqueServiceImpl implements CmsAntiqueService{
	
	@Resource
	private CmsAntiqueMapper cmsAntiqueMapper; 

	@Override
	public void createCmsAntique(List<CmsAntique> antiqueList) {
		
		
		for (CmsAntique cmsAntique : antiqueList) {
			
			String id=UUIDUtils.createUUId();
			
			cmsAntique.setAntiqueId(id);
			cmsAntique.setAntiqueImgUrl("admin/64/201701/Img/Img"+id+".jpg");
			cmsAntique.setAntiqueIsVoice(1);
			cmsAntique.setAntiqueIs3d(1);
			cmsAntique.setAntiqueIsDel(1);
			cmsAntique.setAntiqueState(6);
			cmsAntique.setAntiqueCreateTime(new Date());
			cmsAntique.setAntiqueUpdateTime(new Date());
			cmsAntique.setAntiqueCreateUser("1");
			cmsAntique.setAntiqueUpdateUser("1");
			// 现代
			cmsAntique.setAntiqueDynasty("886f799576874f268e4dcd77bf9998c1");
		
			cmsAntiqueMapper.insert(cmsAntique);
			
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}
	

}
