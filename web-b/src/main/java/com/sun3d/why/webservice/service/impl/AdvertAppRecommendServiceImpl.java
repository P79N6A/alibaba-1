package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.*;
import com.sun3d.why.model.AppAdvertRecommend;
import com.sun3d.why.model.AppAdvertRecommendRfer;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.AdvertAppRecommendService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class AdvertAppRecommendServiceImpl implements AdvertAppRecommendService {
    private Logger logger = Logger.getLogger(AdvertAppRecommendServiceImpl.class);
    @Autowired
    private AppAdvertRecommendMapper appAdvertRecommendMapper;
    @Autowired
    private StaticServer staticServer;

    /**
     * why3.5 app查询广告位列表
     * @param advPostion
     * @return
     */
    @Override
    public String queryAppAdvertRecommendList(String advPostion){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(advPostion)){
            map.put("advPostion", advPostion);
        }

        List<AppAdvertRecommend> list = appAdvertRecommendMapper.queryAppAdvertRecommendList(map);
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        if(CollectionUtils.isNotEmpty(list)){
            for(AppAdvertRecommend advert:list){
                Map<String, Object> mapAdvert = new HashMap<String, Object>();
                mapAdvert.put("isContainActivtiyAdv", advert.getIsContainActivtiyAdv() != null ? advert.getIsContainActivtiyAdv() : "");
                mapAdvert.put("advBannerFIsLink", advert.getAdvBannerFIsLink() != null ? advert.getAdvBannerFIsLink() : "");
                mapAdvert.put("advBannerFLinkType", advert.getAdvBannerFLinkType() != null ? advert.getAdvBannerFLinkType() : "");
                mapAdvert.put("advBannerFUrl", advert.getAdvBannerFUrl() != null ? advert.getAdvBannerFUrl() : "");
                String advBannerFImgUrl = "";
                if(StringUtils.isNotBlank(advert.getAdvBannerFImgUrl())){
                    advBannerFImgUrl = staticServer.getStaticServerUrl() + advert.getAdvBannerFImgUrl();
                }
                mapAdvert.put("advBannerFImgUrl", advBannerFImgUrl);
                mapAdvert.put("advBannerSIsLink", advert.getAdvBannerSIsLink() != null ? advert.getAdvBannerSIsLink() : "");
                mapAdvert.put("advBannerSLinkType", advert.getAdvBannerSLinkType() != null ? advert.getAdvBannerSLinkType() : "");
                mapAdvert.put("advBannerSUrl", advert.getAdvBannerSUrl() != null ? advert.getAdvBannerSUrl() : "");
                String advBannerSImgUrl = "";
                if(StringUtils.isNotBlank(advert.getAdvBannerSImgUrl())){
                    advBannerSImgUrl = staticServer.getStaticServerUrl() + advert.getAdvBannerSImgUrl();
                }
                mapAdvert.put("advBannerSImgUrl", advBannerSImgUrl);
                mapAdvert.put("advBannerLIsLink", advert.getAdvBannerLIsLink() != null ? advert.getAdvBannerLIsLink() : "");
                mapAdvert.put("advBannerLLinkType", advert.getAdvBannerLLinkType() != null ? advert.getAdvBannerLLinkType() : "");
                mapAdvert.put("advBannerLUrl", advert.getAdvBannerLUrl() != null ? advert.getAdvBannerLUrl() : "");
                String advBannerLImgUrl = "";
                if(StringUtils.isNotBlank(advert.getAdvBannerLImgUrl())){
                    advBannerLImgUrl = staticServer.getStaticServerUrl() + advert.getAdvBannerLImgUrl();
                }
                mapAdvert.put("advBannerLImgUrl", advBannerLImgUrl);
                List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
                if(CollectionUtils.isNotEmpty(advert.getDataList())){
                    for(AppAdvertRecommendRfer r:advert.getDataList()){
                        Map<String, Object> rMap = new HashMap<String, Object>();
                        rMap.put("advertUrl", r.getAdvertUrl() != null ? r.getAdvertUrl() : "");
                        String advertImgUrl = "";
                        if(StringUtils.isNotBlank(r.getAdvertImgUrl())) {
                            advertImgUrl = staticServer.getStaticServerUrl() + r.getAdvertImgUrl();
                        }
                        rMap.put("advertImgUrl", advertImgUrl);
                        rMap.put("advertSort", r.getAdvertSort() != null ? r.getAdvertSort() : "");
                        dataList.add(rMap);
                    }
                }
                mapAdvert.put("dataList", dataList);
                mapList.add(mapAdvert);
            }
        }
        return JSONResponse.toAppResultFormat(1, mapList);
    }
}