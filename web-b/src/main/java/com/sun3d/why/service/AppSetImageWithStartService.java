package com.sun3d.why.service;

import com.sun3d.why.model.app.AppImageOfOpen;
import com.sun3d.why.model.topic.*;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ct on 16/9/27.
 */

public interface AppSetImageWithStartService
{

    int delAppImage(int imageid);

    int insertAppImage(AppImageOfOpen obj);


    int updateAppImage(AppImageOfOpen obj);

    AppImageOfOpen selectAppImage(int id);

    List<AppImageOfOpen> selectAppImageList(HashMap<String,String> map);

    int setDefaultOpenImage(HashMap<String,String> map);


}
