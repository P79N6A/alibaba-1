package com.culturecloud.service.rs.openplatform.venue;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.common.CmsTag;
import com.culturecloud.model.bean.venue.CmsVenue;
import com.culturecloud.model.request.api.VenueCreateApi;
import com.culturecloud.model.request.api.VenueCreateVO;
import com.culturecloud.model.response.api.CreateResponseApi;
import com.culturecloud.model.response.api.CreateResponseVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.utils.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

@Component
@Path("/api/venue")
public class VenueResource {

    @Resource
    private BaseService baseService;

    /**
     * 新增场馆
     */
    @POST
    @Path("/create")
    @SysBusinessLog(remark = "新增场馆")
    @Produces(MediaType.APPLICATION_JSON)
    public CreateResponseVO createVenue(VenueCreateVO venueCreateVOs) {
        CreateResponseVO vo = new CreateResponseVO();
        CreateResponseApi api = new CreateResponseApi();
        List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();
        String source = venueCreateVOs.getPlatSource();
        CmsVenue venue = new CmsVenue();
        for (VenueCreateApi venueCreateApi : venueCreateVOs.getVenueList()) {
            try {
                PropertyUtils.copyProperties(venue, venueCreateApi);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(venue.getVenueId())) {
                BizException.Throw("400", "场馆ID不能为空");
            } else {
                List<CmsVenue> act = baseService.find(CmsVenue.class, " where SYS_ID='" + venue.getVenueId() + "'");
                if (act.size() > 0) {
                    BizException.Throw("400", "场馆已存在");
                }
                venue.setSysNo(source);
                venue.setSysId(venueCreateApi.getVenueId());
                venue.setVenueId(UUIDUtils.createUUId());
            }
            if (StringUtils.isBlank(venue.getVenueName())) {
                BizException.Throw("400", "场馆名称不能为空");
            }
            if (StringUtils.isBlank(venue.getVenueArea())) {
                BizException.Throw("400", "场馆区域不能为空");
            }
            if (StringUtils.isBlank(venue.getVenueCity())) {
                BizException.Throw("400", "场馆城市不能为空");
            }
            if (StringUtils.isBlank(venue.getVenueProvince())) {
                BizException.Throw("400", "场馆省份不能为空");
            }
            if (StringUtils.isBlank(venue.getVenueAddress())) {
                BizException.Throw("400", "场馆地址不能为空");
            }
            if (!StringUtils.isBlank(venue.getVenueType())) {
                List<CmsTag> tag = baseService.find(CmsTag.class, " where TAG_NAME like '%" + venue.getVenueType() + "%'");
                if (tag.size() == 0) {
                    venue.setVenueType(null);
                }else{
                    venue.setVenueType(tag.get(0).getTagId());
                }
            }
            venue.setVenueIsDel(1);
            api.setInputId(venueCreateApi.getVenueId());
            api.setOutputId(venue.getVenueId());
            baseService.create(venue);
        }
        list.add(api);
        vo.setList(list);
        return vo;
    }


    /**
     * 编辑场馆
     */
    @POST
    @Path("/update")
    @SysBusinessLog(remark = "编辑场馆")
    @Produces(MediaType.APPLICATION_JSON)
    public CreateResponseVO updateVenue(VenueCreateVO venueCreateVOs) {
        CreateResponseVO vo = new CreateResponseVO();
        CreateResponseApi api = new CreateResponseApi();
        List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();
        CmsVenue venue = new CmsVenue();
        for (VenueCreateApi venueCreateApi : venueCreateVOs.getVenueList()) {
            try {
                PropertyUtils.copyProperties(venue, venueCreateApi);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(venue.getVenueId())) {
                BizException.Throw("400", "场馆ID不能为空");
            } else {
                List<CmsVenue> ven = baseService.find(CmsVenue.class, " where SYS_ID='" + venue.getVenueId() + "'");
                if (ven.size() == 0) {
                    BizException.Throw("400", "场馆不存在");
                }
                venue.setVenueId(ven.get(0).getVenueId());
            }
            if (!StringUtils.isBlank(venue.getVenueType())) {
                List<CmsTag> tag = baseService.find(CmsTag.class, " where TAG_NAME like '%" + venue.getVenueType() + "%'");
                if (tag.size() == 0) {
                    venue.setVenueType(null);
                }else{
                    venue.setVenueType(tag.get(0).getTagId());
                }
            }
            baseService.update(venue, " where SYS_ID='" + venueCreateApi.getVenueId() + "'");
        }
        list.add(api);
        vo.setList(list);
        return vo;
    }


}
