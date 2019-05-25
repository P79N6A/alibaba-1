
package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsAntiqueMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.dao.SysDeptMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import net.sf.json.JSONObject;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.*;

@Service
@Transactional
public class CmsVenueServiceImpl implements CmsVenueService {
    @Autowired
    private CmsVenueMapper cmsVenueMapper;
    @Autowired
    private CmsAntiqueMapper cmsAntiqueMapper;
    @Autowired
    private SysDeptMapper deptMapper;
    @Autowired
    private CmsUserService cmsUserService;
    @Autowired
    private HttpSession session;

    private org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(CmsVenueServiceImpl.class);

    
    @Override
    public List<AreaData> queryVenueAllArea() {
        Map map = new HashMap();

        SysUser user = (SysUser)session.getAttribute("user");
        if (user != null)
              map.put("venueDept", user.getUserDeptPath() + "%");
        List<CmsVenue> venueList = cmsVenueMapper.queryVenueAllArea(map);
        if (CollectionUtils.isEmpty(venueList)) {
            return null;
        }
        List<AreaData> dataList = new ArrayList<AreaData>();
        for (CmsVenue cmsVenue : venueList) {
            String area = cmsVenue.getVenueArea();
            if (StringUtils.isNotBlank(area)) {
                String[] areas = area.split(",");
                AreaData data = new AreaData();
                if (areas.length > 1 && areas[0] != null && areas[1] != null) {
                    data.setId(areas[0]);
                    data.setText(areas[1]);
                    dataList.add(data);
                }
            }
        }
        return dataList;
    }

    @Override
    public List<AreaData> queryVenueAllType(String venueArea) {
        //查询存在的所有场馆\
        Map sqlMap = new HashMap();
        sqlMap.put("venueArea", venueArea + ",%");
        SysUser user = (SysUser)session.getAttribute("user");
        if (user != null) {
            sqlMap.put("venueDept", user.getUserDeptPath() + "%");
        }
       List<Map> listMap =  cmsVenueMapper.queryAllVenueByArea(sqlMap);
        List<AreaData> dataList = new ArrayList<AreaData>();
        if (listMap != null) {
            for(Map map : listMap) {
                AreaData data = new AreaData();
                data.setId(map.get("tagId") != null ? map.get("tagId").toString() : "");
                data.setText(map.get("tagName") != null ? map.get("tagName").toString() : "");
                dataList.add(data);
            }
        }

//        　${path}/tag/getChildTagByType.do?code=VENUE_TYPE
//        　List<CmsTag> list = new ArrayList<CmsTag>();
//          List<SysDict> dicts = sysDictService.querySysDictByCode("VENUE_TYPE");
//        if (dicts != null && dicts.size() > 0) {
//            list  = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
//        }
        //return list;
//        List<AreaData> dataList = new ArrayList<AreaData>();
//        if (CollectionUtils.isNotEmpty(list)) {
//            for (CmsTag cmsTag : list) {
//                AreaData data = new AreaData();
//                data.setId(cmsTag.getTagId());
//                data.setText(cmsTag.getTagName());
//                dataList.add(data);
//            }
//        }
        return dataList;
    }

    @Override
    public List<AreaData> queryVenueNameByAreaAndType(String areaId, String type, SysUser sysUser) {
        CmsVenue cmsVenue = new CmsVenue();
        cmsVenue.setVenueArea(areaId);
        cmsVenue.setVenueType(type);
        cmsVenue.setVenueState(6); //Constant.NORMAL
        String userDeptPath = null;
        if(sysUser != null){
            userDeptPath = sysUser.getUserDeptPath();
            cmsVenue.setUserLabel1(sysUser.getUserLabel1());
            cmsVenue.setUserLabel2(sysUser.getUserLabel2());
            cmsVenue.setUserLabel3(sysUser.getUserLabel3());
        }
        List<CmsVenue> venueList = queryVenueByCondition(cmsVenue, null, null, userDeptPath);
        if (CollectionUtils.isEmpty(venueList)) {
            return null;
        }

        List<AreaData> dataList = new ArrayList<AreaData>();
        for (CmsVenue venue : venueList) {
            String venueId = venue.getVenueId();
            AreaData data = new AreaData();
            data.setId(venueId);
            data.setText(venue.getVenueName());
            dataList.add(data);
        }
        return dataList;
    }

    @Override
    public int deleteVenueById(String venueId) {

        CmsVenue cmsVenue = queryVenueById(venueId);
        if(StringUtils.isNotBlank(cmsVenue.getVenueDeptId())){
            deptMapper.deleteByDeptId(cmsVenue.getVenueDeptId());
        }
        return this.cmsVenueMapper.deleteVenueById(venueId);
    }

    @Override
    public CmsVenue queryVenueById(String venueId){
        return this.cmsVenueMapper.queryVenueById(venueId);
    }

    @Override
    public int updateStateByVenueIds(String venueId,String userId) {
        CmsVenue venue = new CmsVenue();
        venue.setVenueId(venueId);
        venue.setVenueIsDel(Constant.DELETE);
        venue.setVenueState(Constant.TRASH);
        return this.cmsVenueMapper.updateStateByVenueIds(venue);
    }

    @Override
    public int returnVenueByIds(String venueId,String sysNo) {
        CmsVenue venue = new CmsVenue();
        if("1".equals(sysNo)){
            venue.setVenueId(venueId);
            venue.setVenueIsDel(Constant.NORMAL);
            venue.setVenueState(Constant.DRAFT);
            return this.cmsVenueMapper.returnVenue(venue);
        }else{
            venue.setVenueId(venueId);
            venue.setVenueIsDel(Constant.NORMAL);
            venue.setVenueState(Constant.PUBLISH);
            return this.cmsVenueMapper.returnVenue(venue);
        }

    }

    public List<Map<String, Object>> selectByExampleForList(HashMap<String, Object> map) {
        return this.cmsVenueMapper.selectByExampleForList(map);
    }


    /**
     * 带条件查询场馆列表
     * @param venue 场馆查询条件
     * @param page 分页信息
     * @param pageApp
     *@param userDeptPath 用户路径  @return
     */
    @Override
    public List<CmsVenue> queryVenueByCondition(CmsVenue venue, Pagination page, PaginationApp pageApp, String userDeptPath) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(userDeptPath)) {
            map.put("venueDept", userDeptPath);
        }
        if(StringUtils.isNotBlank(venue.getVenueName())){
            map.put("venueName", venue.getVenueName());
        }
        if(StringUtils.isNotBlank(venue.getVenueType())){
            map.put("venueType", venue.getVenueType());
        }
        if(StringUtils.isNotBlank(venue.getVenueCrowd())){
            map.put("venueCrowd", "%"+venue.getVenueCrowd()+"%");
        }
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", venue.getVenueArea());
        }
        if(StringUtils.isNotBlank(venue.getSearchKey())){
            map.put("searchKey", venue.getSearchKey());
        }
        if(venue.getVenueState() != null){
            map.put("venueState", venue.getVenueState());
        }
        if(venue.getUserLabel1() != null){
            map.put("userLabel1", venue.getUserLabel1());
        }
        if(venue.getUserLabel2() != null){
            map.put("userLabel2", venue.getUserLabel2());
        }
        if(venue.getUserLabel3() != null){
            map.put("userLabel3", venue.getUserLabel3());
        }
        if(StringUtils.isNotBlank(venue.getTagId())){
            map.put("tagId", "%"+venue.getTagId()+"%");
        }
        map.put("venueIsDel", Integer.valueOf(venue.getVenueIsDel() == null ? 1 : venue.getVenueIsDel().intValue()));
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryVenueCountByCondition(map);
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());

        }
        return cmsVenueMapper.queryVenueByCondition(map);
    }

    /**
     * 前端场馆列表查询
     * @param venue 场馆查询条件
     * @param page 分页信息
     */
    @Override
    public List<CmsVenue> queryFrontCmsVenueByCondition(CmsVenue venue, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venue.getVenueName())){
            map.put("venueName", venue.getVenueName().replace("_","\\_").replace("%","\\%"));
        }
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", venue.getVenueArea());
        }
        if(venue.getVenueState() != null){
            map.put("venueState", venue.getVenueState());
        }
        if(StringUtils.isNotBlank(venue.getTagId())){
            map.put("tagId", "%"+venue.getTagId()+"%");
        }
        map.put("venueIsDel", Integer.valueOf(venue.getVenueIsDel() == null ? 1 : venue.getVenueIsDel().intValue()));
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryFrontCmsVenueCountByCondition(map);
            page.setTotal(total);
        }
        return cmsVenueMapper.queryFrontCmsVenueByCondition(map);
    }

    /**
     * 带条件查询场馆列表
     * @param venue 场馆查询条件
     * @param page 分页信息
     * @return
     */
    @Override
    public List<CmsVenue> queryVenueByConditionSort(CmsVenue venue, Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("venueIsDel", Constant.NORMAL);
        map.put("venueState", Constant.PUBLISH);

        if(venue != null){
            if(StringUtils.isNotBlank(venue.getVenueName())){
                map.put("venueName", venue.getVenueName().replace("_","\\_").replace("%","\\%"));
            }
            if(StringUtils.isNotBlank(venue.getVenueType())){
                map.put("venueType", venue.getVenueType());
            }
            if(venue.getVenueIsReserve() != null){
                map.put("venueIsReserve", venue.getVenueIsReserve());
            }
            if(StringUtils.isNotBlank(venue.getVenueArea())){
                map.put("venueArea", venue.getVenueArea());
            }
            if(StringUtils.isNoneBlank(venue.getVenueMood())){
                map.put("venueMood", venue.getVenueMood());
            }
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryFrontCmsVenueCountByCondition(map);
            page.setTotal(total);
        }
        return cmsVenueMapper.queryFrontCmsVenueByCondition(map);
    }


    @Override
    public int queryVenueCountByCondition(Map<String, Object> var1) {
        return cmsVenueMapper.queryVenueCountByCondition(var1);
    }


   /* @Override
    public int countBestWelcomeVenue(CmsVenueExample example) {
        return this.cmsVenueMapper.countBestWelcomeVenue(example);
    }*/

   /* @Override
    public List<CmsVenue> queryBestWelcomeVenue(String areaCode, Pagination page) {
        CmsVenueExample example = new CmsVenueExample();
        Criteria criteria = example.createCriteria();
        criteria.andVenueStateEqualTo(Constant.PUBLISH);
        criteria.andVenueIsDelEqualTo(Constant.NORMAL);
        if (areaCode != null && StringUtils.isNotBlank(areaCode)) {
            criteria.andVenueAreaLike(areaCode);
        }

        example.setTotal(this.countBestWelcomeVenue(example));
        example.setPage(page.getPage());
        example.setRows(page.getRows());
        return this.cmsVenueMapper.queryBestWelcomeVenue(example);
    }*/

    @Override
    public List<CmsVenue> queryFrontVenueByCondition(CmsVenue cmsVenue, Pagination page) {

        Map<String, Object> map = new HashMap<String, Object>();
        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueArea())) {
            map.put("venueArea", "%" + cmsVenue.getVenueArea() + "%");
        }

        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueName())) {
            map.put("venueName", cmsVenue.getVenueName());
        }

        //数据状态
        if (cmsVenue != null && cmsVenue.getVenueIsDel() != null && cmsVenue.getVenueIsDel() == 2) {
            map.put("venueIsDel", Constant.DELETE);
        } else {
            map.put("venueIsDel", Constant.NORMAL);

        }
        //场馆类型
        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueType())) {
            map.put("venueType", cmsVenue.getVenueType());
        }

        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryFrontVenueCountByCondition(map);
            page.setTotal(Integer.valueOf(total));
        }

        return cmsVenueMapper.queryFrontVenueByCondition(map);
    }

    @Override
    public Integer queryFrontVenueCountByCondition(Map<String, Object> map) {
        return this.cmsVenueMapper.queryFrontVenueCountByCondition(map);
    }

    @Override
    public List<CmsVenue> queryFrontVenueByCondition(Map<String, Object> map) {
        return this.cmsVenueMapper.queryFrontVenueByCondition(map);
    }

    /**
     * 前台场馆详情时显示相关场馆推荐
     * @param cmsVenue
     * @param page
     * @return
     */
    @Override
    public List<CmsVenue> queryCmsVenue(CmsVenue cmsVenue, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        //数据状态是否删除
        if (cmsVenue != null && cmsVenue.getVenueIsDel() != null && cmsVenue.getVenueIsDel() == 2) {
            map.put("venueIsDel", Constant.DELETE);
        } else {
            map.put("venueIsDel", Constant.NORMAL);
        }
        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueArea())) {
            map.put("venueArea", "%" + cmsVenue.getVenueArea() + "%");
        }
        //数据状态是否已发布
        map.put("venueState", Constant.PUBLISH);

        if (cmsVenue != null && StringUtils.isNotBlank(cmsVenue.getVenueId())) {
            map.put("venueId", cmsVenue.getVenueId());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        // int total = activityMapper.queryCmsActivityCountByCondition(map);
        //设置分页的总条数来获取总页数
        //page.setTotal(total);
        return cmsVenueMapper.queryCmsVenue(map);
    }

    /**
     * 前台场馆显示推荐馆藏
     *
     * @param cmsAntique
     * @param page
     * @return
     */
    @Override
    public List<CmsAntique> queryCmsAntique(CmsAntique cmsAntique, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        //数据状态
        if (cmsAntique != null && cmsAntique.getAntiqueIsDel() != null && cmsAntique.getAntiqueIsDel() == 2) {
            map.put("antiqueIsDel", Constant.DELETE);
        } else {
            map.put("antiqueIsDel", Constant.NORMAL);

        }
        //已发布
        if (cmsAntique != null && cmsAntique.getAntiqueState() != null) {
            map.put("antiqueState", Constant.PUBLISH);
        }
        //场馆名称
        if (cmsAntique != null && StringUtils.isNotBlank(cmsAntique.getVenueId())) {
            map.put("venueId", cmsAntique.getVenueId());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = cmsAntiqueMapper.countAntique(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return cmsAntiqueMapper.queryCmsAntique(map);
    }

    /**
     * 前端2.0场馆收藏列表
     * @param user 会员对象
     * @param venueName 场馆名称
     * @return 场馆对象集合
     */
    @Override
    public List<CmsVenue> queryCollectVenue(CmsTerminalUser user, Pagination page, String venueName) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", user.getUserId());
        map.put("type", Constant.COLLECT_VENUE);
        if(StringUtils.isNotBlank(venueName)){
            map.put("venueName", "%"+venueName+"%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(queryCollectVenueCount(map));
        }

        return cmsVenueMapper.queryCollectVenue(map);
    }

    /**
     * 前端2.0场馆收藏个数
     * @param map
     * @return
     */
    @Override
    public int queryCollectVenueCount(Map<String, Object> map){
        return cmsVenueMapper.queryCollectVenueCount(map);
    }
    ;
    /**
     * 前端详情内容属于什么类型的场馆(余进兵FrontActivityController/getRelateVenue)
     * @param venue
     * @param page 分页
     * @return
     */
    @Override
    public List<CmsVenue> queryFrontActivityByCondition(CmsVenue venue,Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venue.getVenueType())){
            map.put("venueType", venue.getVenueType());
        }
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", venue.getVenueArea());
        }
        if(StringUtils.isNotBlank(venue.getVenueId())){
            map.put("venueId", venue.getVenueId());
        }
        if(venue.getVenueIsDel() != null){
            map.put("venueIsDel", venue.getVenueIsDel());
        }
        if(venue.getVenueState() != null){
            map.put("venueState", venue.getVenueState());
        }

        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return cmsVenueMapper.queryFrontActivityByCondition(map);
    }

    /**
     * 添加场馆
     * @param venue
     * @return
     */
    @Override
    public int addVenue(CmsVenue venue){
        return cmsVenueMapper.addVenue(venue);
    }

    /**
     * 根据id更新场馆
     * @param venue
     * @return
     */
    @Override
    public int editVenueById(CmsVenue venue){

        //赋予默认值
        if (venue.getVenueMon() == null) {
            venue.setVenueMon("2");
        }
        if (venue.getVenueTue() == null) {
            venue.setVenueTue("2");
        }
        if (venue.getVenueWed() == null) {
            venue.setVenueWed("2");
        }
        if (venue.getVenueThu() == null) {
            venue.setVenueThu("2");
        }
        if (venue.getVenueFri() == null) {
            venue.setVenueFri("2");
        }
        if (venue.getVenueSat() == null) {
            venue.setVenueSat("2");
        }
        if (venue.getVenueSun() == null) {
            venue.setVenueSun("2");
        }
        try {
            CmsVenue cmsVenue = queryVenueById(venue.getVenueId());
            /**add by YH 场馆与部门关联，修改场馆时同步更新对应的部门信息  2015-10-30 begin */
            //场馆所在的部门ID
            String deptId = cmsVenue.getVenueDeptId();
            //线上已有数据中部分没有部门或部门ID还没有赋值给场馆表字段
            if(StringUtils.isBlank(deptId) && StringUtils.isNotBlank(venue.getVenueDeptId())){
                deptId = venue.getVenueDeptId();
            }
            String parentDeptId = venue.getVenueParentDeptId();//上级部门ID

            SysDept sysDept = deptMapper.querySysDeptByDeptId(deptId); //新建场馆时对应的部门
            sysDept.setDeptName(venue.getVenueName());
            sysDept.setDeptShortName(venue.getVenueName());
            if(venue.getVenueState() == Constant.PUBLISH){
                sysDept.setDeptState(1);
            }
            if(StringUtils.isNotBlank(parentDeptId)){
                sysDept.setDeptParentId(parentDeptId);
                SysDept parentSysDept = deptMapper.querySysDeptByDeptId(parentDeptId);//上级部门
                sysDept.setDeptPath(parentSysDept.getDeptPath()+"."+deptId);
            }
            deptMapper.editSysDept(sysDept);
            //修改场馆部门路径
            venue.setVenueDept(sysDept.getDeptPath());
            /**add by YH 场馆与部门关联，修改场馆时同步更新对应的部门信息  2015-10-30 end */
            //已经分配管理员的场馆 当场馆名称改变的时候 部门名称也需要跟着改变
            /*if (cmsVenue.getManagerId() != null && StringUtils.isNotBlank(cmsVenue.getManagerId())) {
                SysDept dept = deptMapper.querySysDeptByDeptPath(cmsVenue.getVenueDept());
                if (dept != null) {
                    dept.setDeptName(venue.getVenueName());
                    deptMapper.editSysDept(dept);
                }
            }*/
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return cmsVenueMapper.editVenueById(venue);
    }

    /**
     * 根据id更新场馆
     * @param venue
     * @return
     */
    @Override
    public int editVenueByVenueId(CmsVenue venue){
        return cmsVenueMapper.editVenueById(venue);
    }

    /**
     * 新增和修改场馆时的业务逻辑
     * @param venue
     * @param sysUser
     * @return success:成功 failure:失败 repeat:重复
     */
    @Override
    public int saveVenue(CmsVenue venue, SysUser sysUser){
        int count = 0;
        try{
            venue.setVenueId(UUIDUtils.createUUId());
            SysUser syncUser = cmsUserService.querySysUserByUserAccount("chuangtu_sh");
            venue.setVenueCreateUser(syncUser.getUserId());
            venue.setVenueUpdateUser(syncUser.getUserId());
            venue.setVenueDept(syncUser.getUserDeptPath());
            venue.setVenueUpdateTime(new Date());
            venue.setVenueCreateTime(new Date());
            venue.setVenueIsDel(Constant.NORMAL);
            //如果前端没有勾选，统一置为默认值2
            if(venue.getVenueMon() == null){
                venue.setVenueMon("2");
            }
            if(venue.getVenueTue() == null){
                venue.setVenueTue("2");
            }
            if(venue.getVenueWed() == null){
                venue.setVenueWed("2");
            }
            if(venue.getVenueThu() == null){
                venue.setVenueThu("2");
            }
            if(venue.getVenueFri() == null){
                venue.setVenueFri("2");
            }
            if(venue.getVenueSat() == null){
                venue.setVenueSat("2");
            }
            if(venue.getVenueSun() == null){
                venue.setVenueSun("2");
            }
            //设置子系统添加的场馆都为5颗星星
            if(venue.getVenueStars() == null){
                venue.setVenueStars("5");
            }

            if(StringUtils.isNotBlank(venue.getVenueRoamUrl())){
                //2代表支持虚拟漫游地址
                venue.setVenueIsRoam(2);
            }else{
                //1代表不支持虚拟漫游地址
                venue.setVenueIsRoam(1);
            }
            //保存部门
        	SysDept sysDept = saveDept(venue,sysUser);
        	venue.setVenueDeptId(sysDept.getDeptId());
        	venue.setVenueDept(sysDept.getDeptPath().toString());
            //保存用户
            count = cmsVenueMapper.addVenue(venue);
        }catch (Exception e){
            logger.error("保存场馆失败!",e);
            return count;
        }
        return count;
    }

    /**
     * 分配管理保存
     * @param user
     * @param venueId
     * @param userDeptPath
     * @param userId
     * @return
     */
    @Override
    public String saveAssignManager(SysUser user,String venueId, String userDeptPath, String userId){
        try{
        	/**modify by yh  2015-10-27 可以分配多个管理员 begin */
        	if(user != null){
        		CmsVenue venue = queryVenueById(venueId);
                String newDeptPath = userDeptPath;
                venue.setVenueDept(newDeptPath);
         //     venue.setManagerId(userId);
         //     venue.setVenueUpdateTime(new Date());
                int count = editVenueById(venue);
                cmsUserService.updateUserPath(userId, newDeptPath, user, venue);
                if (count > 0) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
                
        	}
        	
        	/**modify by yh  2015-10-27 可以分配多个管理员 end */
            /*if(user != null){
                CmsVenue venue = queryVenueById(venueId);
                String newDeptPath = userDeptPath;
                venue.setVenueDept(newDeptPath);
                venue.setManagerId(userId);
                venue.setVenueUpdateTime(new Date());
                int count = editVenueById(venue);
                cmsUserService.updateUserPath(userId, newDeptPath, user, venue);
                if (count > 0) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            }*/
        }catch (Exception e){
            logger.info("saveAssignManager error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 得到小时(0-23的数字)
     * @return
     */
    @Override
    public String venueHours(){
        JSONObject json = new JSONObject();
        try{
            List<String> list = new ArrayList<String>();
            String Options = "00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23";
            String[] arr = Options.split(",");
            for (int i = 0; i < arr.length; i++) {
                list.add(arr[i]);
            }
            json.put("data", list);
        }catch (Exception e){
            logger.info("venueHours error", e);
        }
        return json.toString();
    }

    /**
     * 得到分钟(0，15，30，45的数字)
     * @return
     */
    @Override
    public String venueMin(){
        JSONObject json = new JSONObject();
        try{
            List<String> list = new ArrayList<String>();
            String Options = "00,15,30,45";
            String[] arr = Options.split(",");
            for (int i = 0; i < arr.length; i++) {
                list.add(arr[i]);
            }
            json.put("data", list);
        }catch (Exception e){
            logger.info("venueMin error", e);
        }
        return json.toString();
    }



    /**
     * 带条件查询符合的统计数据[平台内容统计--场馆统计]
     * @param cmsVenue
     * @return
     */
    @Override
    public List<CmsVenue> queryVenueStatistic(CmsVenue cmsVenue) {

        return cmsVenueMapper.queryVenueStatistic(cmsVenue);
    }

	@Override
	public CmsVenue queryVenueByKey(String sysId) {
		return null;
	}

    /**
     * 后端3.0场馆评论管理列表
     * @param venue
     * @param page
     * @return 场馆对象集合
     */
    @Override
    public List<CmsVenue> queryVenueCommentByCondition(CmsVenue venue,Pagination page,String userDeptPath){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("commentType", Constant.TYPE_VENUE);
        map.put("venueIsDel", Constant.NORMAL);
        map.put("venueState", Constant.PUBLISH);

        if(StringUtils.isNotBlank(userDeptPath)){
            map.put("venueDept", "%"+userDeptPath+"%");
        }
        if(StringUtils.isNotBlank(venue.getVenueName())){
            map.put("venueName", "%"+venue.getVenueName() + "%");
        }
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", "%"+venue.getVenueArea()+"%");
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryVenueCommentCountByCondition(map);
            page.setTotal(total);
        }

        return cmsVenueMapper.queryVenueCommentByCondition(map);
    }

    /**
     * 后端3.0场馆评论管理列表
     * @param venue
     * @return 场馆对象集合
     */
    @Override
    public List<CmsVenue> queryVenueCommentExitArea(CmsVenue venue,String userDeptPath){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("commentType", Constant.TYPE_VENUE);
        map.put("venueIsDel", Constant.NORMAL);
        map.put("venueState", Constant.PUBLISH);
        if(StringUtils.isNotBlank(userDeptPath)){
            map.put("venueDept", "%"+userDeptPath+"%");
        }
        return cmsVenueMapper.queryVenueCommentByCondition(map);
    }

	@Override
	public int queryVenueOfActivityCountByVenueId(Map<String, Object> map) {
		return cmsVenueMapper.queryVenueOfActivityCountByVenueId(map);
	}

	@Override
	public SysDept saveDept(CmsVenue venue, SysUser sysUser) {
		SysDept sysDept = new SysDept();
        sysDept.setDeptId(UUIDUtils.createUUId());
        sysDept.setDeptUpdateUser(sysUser.getUserId());
        sysDept.setDeptCreateTime(new Date());
        sysDept.setDeptUpdateTime(new Date());
        sysDept.setDeptCreateUser(sysUser.getUserId());
        sysDept.setDeptState(1);
        sysDept.setDeptParentId(venue.getVenueParentDeptId());
        //上级部门
        SysDept parentDept = deptMapper.querySysDeptByDeptId(venue.getVenueParentDeptId());
        sysDept.setDeptPath(parentDept.getDeptPath() + "." + sysDept.getDeptId());
        sysDept.setDeptShortName(venue.getVenueName());
        sysDept.setDeptName(venue.getVenueName());
        sysDept.setDeptSort(this.deptMapper.countMaxSort() + 1);
        sysDept.setDeptIsFromVenue(1);
        //将新建的场馆 保存至部门中
        this.deptMapper.addSysDept(sysDept);
        return sysDept;
	}


    /**
     * 根据部门ID查询场馆信息
     * @param venueDeptId
     * @return
     */
    @Override
    public CmsVenue queryVenueByVenueDeptId(String venueDeptId){

        return cmsVenueMapper.queryVenueByVenueDeptId(venueDeptId);
    }

    /**
     * 根据场馆名称得到场馆的id
     * @param venueName
     * @return
     */
    @Override
    public CmsVenue queryVenueByVenueName(String venueName) {
        return cmsVenueMapper.queryVenueByVenueName(venueName);
    }


    /**
     * 带条件查询场馆列表
     * @param venue 场馆查询条件
     * @param page 分页信息
     * @param pageApp
     *@param userDeptPath 用户路径  @return
     */
    @Override
    public List<CmsVenue> queryRecommendVenueByConditionList(CmsVenue venue, Pagination page, PaginationApp pageApp, String userDeptPath) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (StringUtils.isNotBlank(userDeptPath)) {
            map.put("venueDept", userDeptPath);
        }
        if(StringUtils.isNotBlank(venue.getVenueName())){
            map.put("venueName", venue.getVenueName());
        }
        if(StringUtils.isNotBlank(venue.getVenueType())){
            map.put("venueType", venue.getVenueType());
        }
        if(StringUtils.isNotBlank(venue.getVenueCrowd())){
            map.put("venueCrowd", "%"+venue.getVenueCrowd()+"%");
        }
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", venue.getVenueArea());
        }
        if(StringUtils.isNotBlank(venue.getSearchKey())){
            map.put("searchKey", venue.getSearchKey());
        }
        if(venue.getVenueState() != null){
            map.put("venueState", venue.getVenueState());
        }
        if(StringUtils.isNotBlank(venue.getTagId())){
            map.put("tagId", "%"+venue.getTagId()+"%");
        }
        map.put("venueIsDel", Integer.valueOf(venue.getVenueIsDel() == null ? 1 : venue.getVenueIsDel().intValue()));
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsVenueMapper.queryRecommendVenueCountByCondition(map);
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());

        }
        return cmsVenueMapper.queryRecommendVenueByConditionList(map);
    }

    /**
     * 文化云3.1前端首页推荐场馆
     * @param venue
     * @param page
     * @return
     */
    @Override
    public List<CmsVenue> queryRecommendVenue(CmsVenue venue, Pagination page){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(venue.getVenueArea())){
            map.put("venueArea", venue.getVenueArea()+",%");
        }

        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        return cmsVenueMapper.queryRecommendVenue(map);
    }



    /**
     * 前端页面显示关联的场馆
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    @Override
    public List<CmsVenue> queryRelatedVenue(CmsVenue record,boolean excludeFlag){
        List<CmsVenue> venueList = null;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("venueState", 6);
        map.put("venueIsDel", 1);
        if(StringUtils.isNotBlank(record.getVenueArea())){
            map.put("venueArea", record.getVenueArea());
        }
        if(StringUtils.isNotBlank(record.getVenueId())){
            if(excludeFlag){
                map.put("venueIdExclude", record.getVenueId());
            }else {
                map.put("venueId", record.getVenueId());
            }
        }
        int total = cmsVenueMapper.queryRelatedVenueCount(map);
        record.setTotal(total);
        map.put("firstResult", record.getFirstResult());
        map.put("rows", record.getRows());
        venueList = cmsVenueMapper.queryRelatedVenue(map);
        return venueList;
    }

    /**
     * 前端页面显示关联的场馆数量
     * @param record 活动室查询条件
     * @param excludeFlag 是否排除自己的标记
     * @return
     */
    @Override
    public int queryRelatedVenueCount(CmsVenue record,boolean excludeFlag){
        int total = 0;
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("venueState", 6);
        map.put("venueIsDel", 1);
        if(StringUtils.isNotBlank(record.getVenueArea())){
            map.put("venueArea", record.getVenueArea());
        }
        if(StringUtils.isNotBlank(record.getVenueId())){
            if(excludeFlag){
                map.put("venueIdExclude", record.getVenueId());
            }else {
                map.put("venueId", record.getVenueId());
            }
        }
        total = cmsVenueMapper.queryRelatedVenueCount(map);
        return total;
    }

    public int canleRecommendVenue(String id){

        int total = 0;
        total = cmsVenueMapper.canleRecommendVenue(id);
        return total;
    }

    @Override
    public String queryVenueScore(String venueId) {
        return cmsVenueMapper.queryVenueScore(venueId);
    }

	@Override
	public List<CmsVenue> queryVenueByAreaName(String areaName) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("areaName", areaName);
		map.put("venueState", 6);
		map.put("venueIsDel", 1);
		return cmsVenueMapper.queryFrontCmsVenueByCondition(map);
	}

	@Override
	public List<CmsVenue> pcnewVenue(int num) {
		// TODO Auto-generated method stub
		Map map = new HashMap();
		map.put("venueIsDel", 1);
		map.put("venueState", 6);
		map.put("orderBy", "VENUE_CREATE_TIME DESC");
		
		map.put("firstResult", 0);
		map.put("rows", num);
		return cmsVenueMapper.queryPcnewVenue(map);
	}

    @Override
    public List<CmsVenue> queryVenueUnion(String member, Integer count){
        return cmsVenueMapper.queryVenueUnion(member,count);
    }

    @Override
    public List<CmsVenue> queryVenueByMember(CmsMemberBO bo) {
        List<CmsVenue> list =  cmsVenueMapper.queryVenueByMember(bo);
        bo.setShowPage(false);
        int total =   cmsVenueMapper.queryVenueByMember(bo).size();
        bo.setTotal(total);
        return list;
    }
}
