package com.sun3d.why.service;


import java.util.List;

import javax.servlet.http.HttpSession;

import com.sun3d.why.model.DcFrontUser;
import com.sun3d.why.util.Pagination;

public interface DcFrontService {
     /**
      * 配送用戶登陆
      *
      *
      * @return
      */
     String login(DcFrontUser user, HttpSession session);
     
     
}
