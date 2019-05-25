//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;

/**
 * 同步用户数据至其他平台
 */
public interface SyncCmsTerminalUserService {

	/**
	 * 添加用户
	 * @param terminalUser
	 * @return
	 */
	void addTerminalUser(CmsTerminalUser terminalUser);

	/**
	 * 修改用户
	 * @param terminalUser
	 * @return
	 */
	void editTerminalUser(CmsTerminalUser terminalUser);
}
