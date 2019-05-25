package com.sun3d.why.service.impl;

import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 模块服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * <p/>
 * author wangkun
 */
@Service
@Transactional
public class SysDictServiceImpl implements SysDictService {
    /**
     * 自动注入数据操作层dao实例
     */
    @Autowired
    private SysDictMapper sysDictMapper;


    @Override
    public List<SysDict> querySysDictByByCondition(SysDict sysDict) {
//        Map<String, Object> data = new HashMap<String, Object>();
//        //数据状态
//        if (sysDict != null && sysDict.getDictState() != null) {
//            data.put("dictState", sysDict.getDictState());
//        }
//        //字典编码
//        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictCode())) {
//            data.put("dictCode", sysDict.getDictCode());
//        }
//        //字典名称
//        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictName())) {
//            data.put("dictName", sysDict.getDictCode());
//        }
        return sysDictMapper.querySysDictByByCondition(sysDict);
    }


    @Override
    public int addSysDict(SysDict dict) {
        if (dict != null) {
            dict.setDictId(UUIDUtils.createUUId());
            return sysDictMapper.addSysDict(dict);
        } else {
            return 0;
        }
    }

    @Override
    public SysDict querySysDictByDictId(String dictId) {
        // TODO Auto-generated method stub
        return sysDictMapper.querySysDictByDictId(dictId);
    }

    @Override
    public SysDict querySysDictByDictName(String dictName,String dictCode) {
        // TODO Auto-generated method stub
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("dictName",dictName);
        map.put("dictCode",dictCode);
        return sysDictMapper.querySysDictByDictName(map);
    }


    @Override
    public int editSysDict(SysDict sysDict) {
        // TODO Auto-generated method stub
        return sysDictMapper.editSysDict(sysDict);
    }



    @Override
    public List<SysDict> querySysDictByCode(String code) {
        Map<String, Object> map = new HashMap<String, Object>();
        //数据状态
        map.put("dictState", Constant.NORMAL);
        //字典编码
        if (code != null && StringUtils.isNotBlank(code)) {
            map.put("dictCode", code);
        }
        return sysDictMapper.querySysDictCode(map);
    }


    @Override
    public List<SysDict> querySysDictByCode(SysDict sysDict, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        //数据状态
        map.put("dictState", Constant.NORMAL);
        //字典名称
        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictName())) {
            map.put("dictName", "%" + sysDict.getDictName() + "%");
        }
        //字典编码
        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictCode())) {
            map.put("dictCode", "%"+sysDict.getDictCode() + "%");
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = sysDictMapper.querySysDictCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return sysDictMapper.querySysDictCode(map);

    }


    @Override
    public SysDict querySysDict(SysDict sysDict) {
        Map<String, Object> map = new HashMap<String, Object>();
        //数据状态
        map.put("dictState", Constant.NORMAL);
        //字典名称
        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictName())) {
            map.put("dictName", sysDict.getDictName());
        }
        //字典编码
        if (sysDict != null && StringUtils.isNotBlank(sysDict.getDictCode())) {
            map.put("dictCode", sysDict.getDictCode());
        }

        return sysDictMapper.querySysDict(map);

    }

    public List<SysDict> querySysDictByByMap(Map map) {
        return sysDictMapper.querySysDictByByMap(map);
    }

    public Integer querySysDictCountByByMap(Map map) {
        return sysDictMapper.querySysDictCountByByMap(map);
    }

    @Override
    public String checkDictCanSave(SysDict dict, SysUser sysUser) {
        dict.setDictUpdateTime(new Timestamp(System.currentTimeMillis()));
        dict.setDictCreateTime(new Timestamp(System.currentTimeMillis()));
        dict.setDictState(Constant.NORMAL);
        if (sysUser!=null) {
            dict.setDictCreateUser(sysUser.getUserId());
            dict.setDictUpdateUser(sysUser.getUserId());
        }
        int flag = 0;
        Map map = new HashMap();
        if (StringUtils.isNotBlank(dict.getDictId())) {
            //代表存在该用户，进行更新操作
            flag = sysDictMapper.editSysDict(dict);
        } else {
            //criteria.andDictStateEqualTo(Constant.NORMAL);
            dict.setDictId(UUIDUtils.createUUId());
            map.put("dictState",Constant.NORMAL);
            int count = sysDictMapper.querySysDictCountByByMap(map) == null ? 0 : sysDictMapper.querySysDictCountByByMap(map) ;
            if (count > 0) {
                if (dict.getDictCode() != null && StringUtils.isNotBlank(dict.getDictCode())) {
                    //criteria.andDictCodeEqualTo(dict.getDictCode());
                    map.put("dictCode",dict.getDictCode());
                }
                if (dict.getDictName() != null
                        && StringUtils.isNotBlank(dict.getDictName())) {
                    map.put("dictName",dict.getDictName());
                }
                List<SysDict> list = sysDictMapper.querySysDictByByMap(map);
                if (list.size() > 0) {
                    return "toAdd";
                } else {
                    dict.setDictSort(count + 1);
                }
            } else {
                dict.setDictSort(1);
            }
            if(StringUtils.isBlank(dict.getDictParentId())){
                dict.setDictParentId(null);
            }
            flag = sysDictMapper.addSysDict(dict);
        }
        return "success";
    }


    /**
     * app根据类型code获取类别集合
     * @param sysAntiqueDict
     * @return
     */
    @Override
    public List<SysDict> querySysDictByAntique(SysDict sysAntiqueDict) {
        Map<String,Object> map = new HashMap<String, Object>();
        //数据状态
        if (sysAntiqueDict != null && sysAntiqueDict.getDictState()!= null && sysAntiqueDict.getDictState() == 2) {
            map.put("dictState", Constant.DELETE);
        } else {
            map.put("dictState", Constant.NORMAL);

        }
        //字典编码
        if (sysAntiqueDict != null && StringUtils.isNotBlank(sysAntiqueDict.getDictCode())) {
            map.put("dictCode", sysAntiqueDict.getDictCode());
        }
        return sysDictMapper.querySysDictByAntique(map);
    }


    /**
     * 根据状态,parentId为空查询字典列表信息
     * @return 字典对象
     */
    public List<SysDict> querySysDictByByState(){
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("dictState", Constant.NORMAL);
        return sysDictMapper.querySysDictByByState(map);
    }

    @Override
    public List<SysDict> queryAppDictByCondition(SysDict sysDynastyDict) {

        return sysDictMapper.queryAppDictByCondition(sysDynastyDict);
    }

    /**
     * app获取非遗产名称
     * @param cultureSystem 字典code
     * @return List<SysDict>
     */
    @Override
    public String queryAppSysDictByCode(String cultureSystem) {
        List<Map<String, Object>> mapTypeList = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("dictState", Constant.NORMAL);
        map.put("dictCode",cultureSystem);
        List<SysDict> dictTypes = sysDictMapper.queryAppSysDictByCode(map);
        if (dictTypes != null && dictTypes.size() > 0) {
            for(SysDict dictTypeList:dictTypes){
                Map<String, Object> mapType= new HashMap<String, Object>();
                mapType.put("tagId",dictTypeList.getDictId()!=null?dictTypeList.getDictId():"");
                mapType.put("tagName",dictTypeList.getDictName()!=null?dictTypeList.getDictName():"");
                mapTypeList.add(mapType);
            }
        }
        return JSONResponse.toAppResultFormat(0, mapTypeList);
    }

    @Override
    public List<SysDict> querySysDictByParentCode(String parentCode) {
        return sysDictMapper.querySysDictByParentCode(parentCode);
    }

    public  List<SysDict> querySysDictListByIds(String ids){
        List<String> idList = new ArrayList<>();
        String [] idArr = ids.split(",");
        for(String id : idArr){
            idList.add(id);
        }
        return  sysDictMapper.querySysDictListByIds(idList);
    }


	@Override
	public List<SysDict> querySysdictName(SysDict sysDynastyDict) {
		return sysDictMapper.querySysdictName(sysDynastyDict);
	}

    @Override
    public String selectDictCodeByZJ(String townArea) {
        return sysDictMapper.selectDictCodeByZJ(townArea);
    }
}
