package com.sun3d.why.webservice.service;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.util.PaginationApp;
public interface TeamUserAppService {

    /**
     * app根据用户id判断用户是否为团体用户
     * @param userId 用户id
     * @return
     */
  public  String queryAppTeamUserList(String userId);
  
  public String addCmsTeamUser(CmsTeamUser teamUser,String []teamUserDetailPics,String roomOrderId);
  
  public String editCmsTeamUser(CmsTeamUser teamUser,String []teamUserDetailPics,String roomOrderId);
}
