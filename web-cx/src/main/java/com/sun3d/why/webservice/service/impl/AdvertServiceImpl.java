package com.sun3d.why.webservice.service.impl;
import com.sun3d.why.dao.CmsAdvertMapper;
import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.AdvertService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
@Service
@Transactional
public class AdvertServiceImpl implements AdvertService {
    private Logger logger = Logger.getLogger(AdvertServiceImpl.class);
    @Autowired
    private CmsAdvertMapper cmsAdvertMapper;
    @Autowired
    private StaticServer staticServer;

    /**
     * app获取首页轮播图
     * @return
     */
    @Override
    public String queryAppAdvertBySite(int type) {
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        try {
            List<CmsAdvert> list=cmsAdvertMapper.queryAppAdvertBySite(type);
            if (CollectionUtils.isNotEmpty(list)) {
                for (CmsAdvert advertList : list) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("advertId", advertList.getAdvertId() != null ? advertList.getAdvertId() : "");
                    map.put("advertPosSort", advertList.getAdvertPosSort() != null ? advertList.getAdvertPosSort() : "");
                    map.put("advertTitle",advertList.getAdvertTitle() != null ? advertList.getAdvertTitle() : "");
                    String advertPicUrl = "";
                    if (StringUtils.isNotBlank(advertList.getAdvertPicUrl())) {
                        advertPicUrl = staticServer.getStaticServerUrl() + advertList.getAdvertPicUrl();
                    }
                    map.put("advertPicUrl", advertPicUrl);
                    if(StringUtils.isNotBlank(advertList.getDictName())){
                        if(advertList.getDictName().equals("活动")){
                            map.put("adverType",1);
                        }else if(advertList.getDictName().equals("场馆")){
                            map.put("adverType",2);
                        }else if(advertList.getDictName().equals("团体")){
                            map.put("adverType",3);
                        }
                    }else{
                    	map.put("adverType",1);
                    }
                   // String advertConnectUrl="";
                   // if(StringUtils.isNotBlank(advertList.getAdvertConnectUrl())){
                     map.put("advertConnectUrlId",advertList.getAdvertConnectUrl()!=null?advertList.getAdvertConnectUrl():"");
                     map.put("advertContent", advertList.getAdvertContent() == null ? "" : advertList.getAdvertContent());
                    /*if(StringUtils.isNotBlank(advertList.getAdvertConnectUrl()) && advertList.getAdvertConnectUrl().contains("http://")){
                        String[] advertConnect=advertList.getAdvertConnectUrl().split("=");
                        advertConnectUrl=advertConnect[1].toString();
                    }*/
                  //  map.put("advertConnectUrlId",advertConnectUrl);
                    mapList.add(map);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.error("query advert error!"+e.getMessage());
        }
        return JSONResponse.toAppResultFormat(0, mapList);
    }

    /**
     * 根据advertId查询广告信息
     * @prama String advertId
     * @prama HttpServletRequest request
     * @return CmsAdvert
     * @authours hucheng
     * @date 2016/3/11
     * @content add
     *
     * */
   public  CmsAdvert queryWcCmsAdvertById(String advertId){

       if(StringUtils.isNotBlank(advertId)){
           CmsAdvert advert = cmsAdvertMapper.queryCmsAdvertById(advertId);
           return advert;
       }
       return null;
    }

}
