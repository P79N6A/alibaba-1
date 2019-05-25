package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsTerminalUserData;

import javax.servlet.http.HttpSession;

/**
 * Created by chenjie on 2016/2/29.
 */
public interface CmsApiTerminalUserService {

    /**
     * 添加用户信息
     * @param apiData 用户数据
     * @return
     * @throws Exception
     */
    public CmsApiMessage save(CmsApiData<CmsTerminalUserData> apiData) throws Exception;

    /**
     * 修改用户信息
     * @param apiData 用户数据
     * @param functionCode 操作编号
     * @return
     * @throws Exception
     */
    public CmsApiMessage update(CmsApiData<CmsTerminalUserData> apiData,Integer functionCode) throws Exception;

    /**
     * 删除用户信息【此方法暂不可用】
     * @param apiData 用户数据
     * @return
     * @throws Exception
     */
    public CmsApiMessage delete(CmsApiData<CmsTerminalUserData> apiData) throws Exception;

    CmsTerminalUser webLogin(String userId);

    String addTerminalUser(CmsTerminalUser user);

}
