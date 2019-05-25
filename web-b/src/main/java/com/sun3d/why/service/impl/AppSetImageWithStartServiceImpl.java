package com.sun3d.why.service.impl;

import com.github.pagehelper.PageHelper;
import com.sun3d.why.dao.AppImageWithStartMapper;
import com.sun3d.why.model.app.AppImageOfOpen;
import com.sun3d.why.service.AppSetImageWithStartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;

/**
 * Created by ct on 2017/3/6.
 */
@Service
@Transactional
public class AppSetImageWithStartServiceImpl implements AppSetImageWithStartService
{

    @Autowired
    AppImageWithStartMapper mapper;

    @Override
    public int delAppImage(int imageid) {
        return mapper.delAppImage(imageid);
    }

    @Override
    public synchronized   int  insertAppImage(AppImageOfOpen obj)
    {
        if(obj.getIsDefaultImage() == 1)
        {
            HashMap<String,String> map = new HashMap<>();
            map.put("city",obj.getCity());
            map.put("imageid",obj.getImageid()+"");
            mapper.removeDefaultOpenImage(map);
        }
        return  mapper.insertAppImage(obj);

    }

    @Override
    public int updateAppImage(AppImageOfOpen obj)
    {
        if(obj.getIsDefaultImage() == 1)
        {
            HashMap<String,String> map = new HashMap<>();
            map.put("city",obj.getCity());
            map.put("imageid",obj.getImageid()+"");
            mapper.removeDefaultOpenImage(map);
        }
        return mapper.updateAppImage(obj);
    }

    @Override
    public AppImageOfOpen selectAppImage(int id) {
        return mapper.selectAppImage(id);
    }

    @Override
    public List<AppImageOfOpen> selectAppImageList(HashMap<String,String> map)
    {
        PageHelper.startPage(Integer.parseInt(map.get("page")), 10);
        return mapper.selectAppImageList(map);
    }



    @Override
    public int setDefaultOpenImage(HashMap<String,String> map)
    {
        mapper.removeDefaultOpenImage(map);
        return mapper.setDefaultOpenImage(map);
    }

}
