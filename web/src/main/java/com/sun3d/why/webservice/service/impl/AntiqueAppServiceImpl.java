package com.sun3d.why.webservice.service.impl;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsAntiqueMapper;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsAntiqueType;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsAntiqueTypeService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.AntiqueAppService;

/**
 * 藏品列表
 */
@Service
@Transactional
public class AntiqueAppServiceImpl implements AntiqueAppService {
    private Logger logger = Logger.getLogger(AntiqueAppServiceImpl.class);
    @Autowired
    private CmsAntiqueMapper cmsAntiqueMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsAntiqueTypeService cmsAntiqueTypeService;
    @Autowired
    private SysDictService sysDictService;
    
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;
    
    /**
     * app根据展馆id获取藏品列表
     * @param venueId 展馆id
     * @param pageApp 分页对象
     * @return
     */
    @Override
    public String queryAppAntiqueListById(String venueId, PaginationApp pageApp) {
        Map<String,Object> map = new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listMapAntique = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> listMapDynasty = new ArrayList<Map<String, Object>>();
        map.put("antiqueIsDel", Constant.NORMAL);
        map.put("antiqueState",Constant.PUBLISH);
        if(venueId!=null && StringUtils.isNotBlank(venueId)){
            map.put("venueId",venueId);
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        int count = cmsAntiqueMapper.queryAppAntiqueListCount(map);
        try {
            List<CmsAntique> antiqueList = cmsAntiqueMapper.queryAppAntiqueList(map);
            if(CollectionUtils.isNotEmpty(antiqueList)){
                for(CmsAntique antique:antiqueList){
                    Map<String, Object> antiqueMap = new HashMap<String, Object>();
                    antiqueMap.put("antiqueId", antique.getAntiqueId()!=null?antique.getAntiqueId():"");
                    antiqueMap.put("antiqueName",antique.getAntiqueName()!=null?antique.getAntiqueName():"");
                    String antiqueImgUrl="";
                    if(StringUtils.isNotBlank(antique.getAntiqueImgUrl())){
                        antiqueImgUrl=staticServer.getStaticServerUrl()+antique.getAntiqueImgUrl();
                    }
                    antiqueMap.put("antiqueImgUrl",antiqueImgUrl);
                    
//                    URL url;
//					try {
//						url = new URL(antiqueImgUrl);
//						
//						 BufferedImage src = javax.imageio.ImageIO.read(url);
//				     	  
//	                     	float height=src.getHeight();
//	                     	float width=src.getWidth();
//	                     	
//	                     	float h=(360/width)*height;
//	                        
//	                        antiqueMap.put("height",h);
//	                       
//					} catch (IOException e) {
//						  antiqueMap.put("height",500);
//					}
//                    
                    
                    antiqueMap.put("antiqueTime",antique.getDictName()!=null?antique.getDictName():"");
                    listMap.add(antiqueMap);
                }
            }
            //封装类别code集合
            List<CmsAntiqueType> antiqueTypeList=cmsAntiqueTypeService.queryAppAntiqueType(venueId);
            if(CollectionUtils.isNotEmpty(antiqueTypeList)) {
                for (CmsAntiqueType que : antiqueTypeList) {
                    Map<String, Object> antiqueTypeName = new HashMap<String, Object>();
                    antiqueTypeName.put("antique", que.getAntiqueTypeName());
                    listMapAntique.add(antiqueTypeName);
                }
            }
            //封装朝代code集合
            SysDict sysDynastyDict = new SysDict();
            sysDynastyDict.setDictCode(Constant.DYNASTY);
            // 1-正常 2-删除
            sysDynastyDict.setDictState(Constant.NORMAL);
            List<SysDict> DynastyList = sysDictService.queryAppDictByCondition(sysDynastyDict);
            if(CollectionUtils.isNotEmpty(DynastyList)) {
                for (SysDict dy : DynastyList) {
                    Map<String, Object> DictName = new HashMap<String, Object>();
                    DictName.put("dynasty", dy.getDictName());
                    listMapDynasty.add(DictName);
                }
            }
        } catch (Exception e) {
            logger.error("获取藏品列表出错!",e);
        }
        return JSONResponse.toFourParamterResult(0, listMap, listMapAntique, listMapDynasty, count);
    }
    
    @Override
	public String queryAppAntiqueList(String antiqueTypeName, String antiqueDynasty, PaginationApp pageApp,
			String venueId) {
    	
    	
    	   List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
           Map<String,Object> map=new HashMap<String, Object>();
           if (antiqueTypeName!=null && StringUtils.isNotBlank(antiqueTypeName)) {
               map.put("antiqueTypeName",antiqueTypeName);
           }
           
           if(antiqueDynasty!=null && StringUtils.isNotBlank(antiqueDynasty)){
               map.put("antiqueDynasty",antiqueDynasty);
           }
           
             map.put("antiqueTypeState",Constant.NORMAL);
            if (venueId!=null && StringUtils.isNotBlank(venueId)){
               map.put("venueId",venueId);
            }
           if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
               map.put("firstResult", pageApp.getFirstResult());
               map.put("rows", pageApp.getRows());
           }
           List<CmsAntique> antiqueList=cmsAntiqueMapper.queryAppAntique(map);
           if (CollectionUtils.isNotEmpty(antiqueList)) {
               for (CmsAntique antiques : antiqueList) {
                   Map<String, Object> antiqueMap = new HashMap<String, Object>();
                   antiqueMap.put("antiqueId", antiques.getAntiqueId() != null ? antiques.getAntiqueId() : "");
                   antiqueMap.put("antiqueName", antiques.getAntiqueName() != null ? antiques.getAntiqueName() : "");
                   antiqueMap.put("antiqueTime", antiques.getDictName() != null ? antiques.getDictName() : "");
                   String antiqueImgUrl = "";
                   if (StringUtils.isNotBlank(antiques.getAntiqueImgUrl())) {
                       antiqueImgUrl = staticServer.getStaticServerUrl() + antiques.getAntiqueImgUrl();
                   }
                   antiqueMap.put("antiqueImgUrl", antiqueImgUrl);
                   
                   listMap.add(antiqueMap);
               }
           }
            return  JSONResponse.toAppResultFormat(0,listMap);
	}

    /**
     * app根据藏品类型名称筛选藏品
     * @param antiqueTypeName 藏品类别名称
     * @param pageApp 分页对象
     * @param venueId 展馆id
     * @return
     */
    @Override
    public String queryAppAntiqueListByTypeName(String antiqueTypeName, PaginationApp pageApp,String venueId) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String, Object>();
        if (antiqueTypeName!=null && StringUtils.isNotBlank(antiqueTypeName)) {
            map.put("antiqueTypeName","%"+antiqueTypeName+"%");
        }
          map.put("antiqueTypeState",Constant.NORMAL);
         if (venueId!=null && StringUtils.isNotBlank(venueId)){
            map.put("venueId",venueId);
         }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsAntique> antiqueList=cmsAntiqueMapper.queryAppAntiqueTypeNameList(map);
        if (CollectionUtils.isNotEmpty(antiqueList)) {
            for (CmsAntique antiques : antiqueList) {
                Map<String, Object> antiqueMap = new HashMap<String, Object>();
                antiqueMap.put("antiqueId", antiques.getAntiqueId() != null ? antiques.getAntiqueId() : "");
                antiqueMap.put("antiqueName", antiques.getAntiqueName() != null ? antiques.getAntiqueName() : "");
                antiqueMap.put("antiqueTime", antiques.getDictName() != null ? antiques.getDictName() : "");
                String antiqueImgUrl = "";
                if (StringUtils.isNotBlank(antiques.getAntiqueImgUrl())) {
                    antiqueImgUrl = staticServer.getStaticServerUrl() + antiques.getAntiqueImgUrl();
                }
                antiqueMap.put("antiqueImgUrl", antiqueImgUrl);
                listMap.add(antiqueMap);
            }
        }
         return  JSONResponse.toAppResultFormat(0,listMap);
    }
    /**
     * app根据藏品年代获取藏品列表
     * @param antiqueDynasty 藏品类别名称
     * @param pageApp 分页对象
     * @param venueId 展馆id
     * @return
     */
    @Override
    public String queryAppAntiqueListByDynasty(String antiqueDynasty, PaginationApp pageApp,String  venueId) {
        Map<String,Object> map=new HashMap<String, Object>();
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        if(antiqueDynasty!=null && StringUtils.isNotBlank(antiqueDynasty)){
            map.put("antiqueDynasty",antiqueDynasty);
        }
         if(venueId!=null && StringUtils.isNotBlank(venueId)){
           map.put("venueId",venueId);
         }
            map.put("dictState",Constant.NORMAL);
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        List<CmsAntique> antiqueList= cmsAntiqueMapper.queryAppAntiqueDynastyList(map);
        if (CollectionUtils.isNotEmpty(antiqueList)) {
            for (CmsAntique antiques : antiqueList) {
                Map<String, Object> antiqueMap = new HashMap<String, Object>();
                antiqueMap.put("antiqueId", antiques.getAntiqueId() != null ? antiques.getAntiqueId() : "");
                antiqueMap.put("antiqueName", antiques.getAntiqueName() != null ? antiques.getAntiqueName() : "");
                antiqueMap.put("antiqueTime", antiques.getDictName() != null ? antiques.getDictName() : "");
                String antiqueImgUrl = "";
                if (StringUtils.isNotBlank(antiques.getAntiqueImgUrl())) {
                    antiqueImgUrl = staticServer.getStaticServerUrl() + antiques.getAntiqueImgUrl();
                }
                antiqueMap.put("antiqueImgUrl", antiqueImgUrl);
                listMap.add(antiqueMap);
            }
        }
        return  JSONResponse.toAppResultFormat(0,listMap);
    }

    /**
     * app根据藏品id获取藏品信息
     * @param antiqueId 藏品id
     * @return
     */
    @Override
    public String queryAppAntiqueById(String antiqueId,String userId) {
        List<Map<String,Object>> listMap=new ArrayList<Map<String, Object>>();
        CmsAntique cmsAntique= cmsAntiqueMapper.queryCmsAntiqueById(antiqueId);
        
        if(cmsAntique.getAntiqueId()!=null){
                Map<String, Object> antiqueMap = new HashMap<String, Object>();
                antiqueMap.put("antiqueId", cmsAntique.getAntiqueId() != null ? cmsAntique.getAntiqueId() : "");
                antiqueMap.put("antiqueName", cmsAntique.getAntiqueName() != null ? cmsAntique.getAntiqueName() : "");
                String antiqueImgUrl = "";
                if (StringUtils.isNotBlank(cmsAntique.getAntiqueImgUrl())) {
                    antiqueImgUrl = staticServer.getStaticServerUrl() + cmsAntique.getAntiqueImgUrl();
                }
                antiqueMap.put("antiqueImgUrl", antiqueImgUrl);
                antiqueMap.put("antiqueDynastyName", cmsAntique.getDynastyName() != null ? cmsAntique.getDynastyName() : "");
                //藏品类型
                antiqueMap.put("antiqueSpectfication",cmsAntique.getAntiqueSpecification()!=null?cmsAntique.getAntiqueSpecification():"");
                antiqueMap.put("venueName", cmsAntique.getVenueName()!=null?cmsAntique.getVenueName():"");
                antiqueMap.put("antiqueRemark", cmsAntique.getAntiqueRemark()!=null?cmsAntique.getAntiqueRemark():"");
                String antiqueVoiceUrl = "";
                if (StringUtils.isNotBlank(cmsAntique.getAntiqueVoiceUrl())) {
                    antiqueVoiceUrl = staticServer.getStaticServerUrl() + cmsAntique.getAntiqueVoiceUrl();
                }
                antiqueMap.put("antiqueVideoUrl", cmsAntique.getAntiqueVideoUrl()!=null?cmsAntique.getAntiqueVideoUrl():"");
                antiqueMap.put("antiqueVoiceUrl", antiqueVoiceUrl);
                antiqueMap.put("wantCount", cmsAntique.getWantCount()!=null?cmsAntique.getWantCount():0);
                
                if(StringUtils.isNotBlank(userId))
                {
                	 CmsUserWantgo model=new CmsUserWantgo();
                     model.setUserId(userId);
                     model.setRelateId( cmsAntique.getAntiqueId());
                     
                     int isWantGo=cmsUserWantgoMapper.queryAppUserWantCountById(model);
                     
                     antiqueMap.put("isWantGo", isWantGo);
                }
                else
                	 antiqueMap.put("isWantGo", 0);
                
                listMap.add(antiqueMap);
        }
        return JSONResponse.toAppResultFormat(0,listMap);
    }

	
}
