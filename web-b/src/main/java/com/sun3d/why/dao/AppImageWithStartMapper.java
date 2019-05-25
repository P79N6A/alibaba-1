package com.sun3d.why.dao;

import com.sun3d.why.model.app.AppImageOfOpen;
import com.sun3d.why.model.topic.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/28.
 */
public interface AppImageWithStartMapper
{

    int delAppImage(int imageid);

    int insertAppImage(AppImageOfOpen obj);


    int updateAppImage(AppImageOfOpen obj);

    AppImageOfOpen selectAppImage(int id);

    List<AppImageOfOpen> selectAppImageList(HashMap<String,String> map);

    int setDefaultOpenImage(HashMap<String,String> map);

    int removeDefaultOpenImage(HashMap<String,String> map);

}
