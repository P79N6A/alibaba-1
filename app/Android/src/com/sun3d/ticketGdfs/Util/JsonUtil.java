package com.sun3d.ticketGdfs.Util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.sun3d.ticketGdfs.entity.UserInfo;
import com.sun3d.ticketGdfs.entity.VenueRoomEntity;
import com.sun3d.ticketGdfs.entity.VeriVenueInfo;
import com.sun3d.ticketGdfs.entity.VerificationInfo;

import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Json 解析类
 *
 * @author yangyoutao
 */

public class JsonUtil {
    private static String TAG = "JsonUtil";
    public static String JsonMSG = "请求失败";
    public static String status = "";
    public static String count;//活动赛选数
    public static String orderValidateCodeType = null;

    public static String getJsonStatus(String result) {
        JsonMSG = "请求失败";
        String Mystatus = "error";
        try {
            JSONObject json = new JSONObject(result);
            JsonMSG = json.optString("data");
            status = Mystatus = json.optString("status");
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return Mystatus;
    }

    /**
     * 活动验证信息
     */
    public static VerificationInfo getActivityVeri(String result) {
        VerificationInfo mVeri = null;
        JSONObject data;
        try {
            data = new JSONObject(result);
            status = data.optString("status");
            JsonMSG = data.optString("data");
            JSONArray array = data.optJSONArray("data");
            if (array != null) {
                JSONObject info = array.optJSONObject(0);
                if (null != info) {
                    mVeri = new VerificationInfo();
                    mVeri.setActivityTitle(info.optString("activityName"));
                    mVeri.setAddress(info.getString("activityAddress"));
                    mVeri.setNumber(info.getString("orderVotes"));
                    mVeri.setOrderNumber(info.getString("orderNumber"));
                    mVeri.setPhoneNumber(info.getString("orderPhotoNo"));
                    mVeri.setScreenings(info.getString("activityTime"));
                    mVeri.setSeat(info.getString("activitySeats"));
                    mVeri.setState(info.getString("orderPayStatus"));
                    mVeri.setTicketCode(info.getString("orderValidateCode"));
                    mVeri.setSeatStatus(info.optString("seatStatus"));
                }
                Log.i("TAG_veri", info.toString());
            }

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return mVeri;
    }

    public static String isSelect(String result) {
        JSONObject data;
        try {
            data = new JSONObject(result);
            orderValidateCodeType = data.optString("orderValidateCodeType");
            //如果请求失败没有orderValidateCodeType为空字符，JsonMSG为后台返回的错误提示信息
            JsonMSG = data.optString("data");
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return orderValidateCodeType;
    }

    /**
     * 活动信息确认
     */
    public static String getConfirmActivity(String result) {
        String res = "";
        JSONObject data;
        try {
            data = new JSONObject(result);
            status = data.optString("status");
            JsonMSG = data.optString("data");
            JSONArray array = data.optJSONArray("data");
            if (array != null) {
                JSONObject info = array.optJSONObject(0);
                if (null != info) {
                    res = info.getString("orderPayStatus");
                }
                Log.i("TAG_veri", res);
            }

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return res;
    }


    /**
     * 文化预告列表解析
     *
     * @param result
     * @return
     */

    public static List<VenueRoomEntity> getVenueRoomEntityFromString(String result) {
        List<VenueRoomEntity> venueRoomEntityList = null;
        if (null != result) {
            Gson gson = new Gson();
            JsonParser parser = new JsonParser();
            venueRoomEntityList = new ArrayList<VenueRoomEntity>();
            try {
                JsonObject jsonObject = parser.parse(result).getAsJsonObject();
                status = jsonObject.get("status").toString();
                if (jsonObject != null) {
                    JsonArray jsonArray = jsonObject.getAsJsonArray("data");
                    if (jsonArray.size() != 0) {
                        for (int i = 0; i < jsonArray.size(); i++) {
                            JsonElement el = jsonArray.get(i);
                            VenueRoomEntity cultureEntity = gson.fromJson(el,
                                    VenueRoomEntity.class);
                            venueRoomEntityList.add(cultureEntity);
                        }
                    }
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                Log.d(TAG, e.toString());
            }

        }
        return venueRoomEntityList;
    }

    /**
     * 活动场馆信息
     */
    public static VeriVenueInfo getVeriVenueInfo(String result) {
        VeriVenueInfo mVenue = null;

        JSONObject data;
        try {
            data = new JSONObject(result);
            status = data.optString("status");
            JsonMSG = data.optString("data");
            JSONArray array = data.optJSONArray("data");
            if (array != null) {
                JSONObject info = array.optJSONObject(0);
                if (info != null) {
                    mVenue = new VeriVenueInfo();
                    mVenue.setBookStatus(info.optString("bookStatus"));
                    mVenue.setCurDate(info.optString("curDate"));
                    mVenue.setOpenPeriod(info.optString("roomTime"));//6.27 link修改
//                    mVenue.setOpenPeriod(info.optString("openPeriod"));
                    mVenue.setVenueAddress(info.optString("venueAddress"));
                    mVenue.setRoomName(info.optString("roomName"));
                    mVenue.setValidCode(info.optString("validCode"));
                    mVenue.setRoomOderId(info.optString("roomOderId"));
                    mVenue.setOrderIds(info.optString("orderIds"));
                    mVenue.setTuserTeamName(info.optString("tuserTeamName"));
                    mVenue.setVenueName(info.optString("venueName"));
                    mVenue.setRoomOrderNo(info.optString("roomOrderNo"));
                    mVenue.setOrderTel(info.optString("orderTel"));
                    mVenue.setOrderStatus(info.optString("orderStatus"));

                }
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }


        return mVenue;
    }

    /**
     * 活动场馆信息确认
     */
    public static String getConfirmVenue(String result) {
        String res = "";
        JSONObject data;
        try {
            data = new JSONObject(result);
            status = data.optString("status");
            JSONArray array = data.optJSONArray("data");
            if (array != null) {
                JSONObject info = array.optJSONObject(0);
                if (null != info) {
                    res = info.getString("bookStatus");
                }
                Log.i("TAG_veri", info.toString());
            }

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return res;
    }

    /**
     * 登录，用户信息
     */
    public static UserInfo getUserInfo(String result) {
        UserInfo user = null;
        JSONObject data;
        try {
            data = new JSONObject(result);
            status = data.optString("status");
            JSONArray array = data.optJSONArray("data");
            if (array != null) {
                JSONObject obj = array.optJSONObject(0);
                user = new UserInfo();
                user.setUserNema(obj.getString("userAccount"));
                user.setFigure(obj.getString("roleName"));
                user.setBelonging(obj.getString("deptName"));
                user.setUserId(obj.optString("userId"));
                Log.d(TAG, user.toString());
            }

        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return user;
    }


    /**
     * 用户信息解析
     *
     * @param result
     * @return UserInfor
     */
    /*public static UserInfor getUserInforFromString(String result) {
        UserInfor mUserInfor = null;
		try {
			JSONObject data = new JSONObject(result);
			status = data.optInt("status");
			JSONArray array = data.optJSONArray("data");
			if (array != null) {
				JSONObject User = array.optJSONObject(0);
				if (null != User) {
					mUserInfor = new UserInfor();
					mUserInfor.setUserAge(User.optInt("userAge"));
					mUserInfor.setUserArea(TextUtil.getAddresHandler(User.optString("userArea")));
					mUserInfor.setUserBirth(TextUtil.TimeFormat(User.optLong("userBirth")));
					mUserInfor.setUserCity(TextUtil.getAddresHandler(User.optString("userCity")));
					mUserInfor.setUserEmail(User.optString("userEmail"));
					mUserInfor.setUserHeadImgUrl(User.optString("userHeadImgUrl"));
					mUserInfor.setUserId(User.optString("userId"));
					mUserInfor.setUserIsDisable(User.optInt("userIsDisable"));
					mUserInfor.setUserMobileNo(User.optString("userMobileNo"));
					mUserInfor.setUserName(User.optString("userName"));
					mUserInfor.setUserNickName(User.optString("userNickName"));
					mUserInfor.setUserProvince(TextUtil.getAddresHandler(User
							.optString("userProvince")));
					mUserInfor.setUserPwd(User.optString("userPwd"));
					mUserInfor.setUserQq(User.optString("userQq"));
					mUserInfor.setUserSex(User.optInt("userSex"));
					mUserInfor.setUserType(User.optInt("userType"));
					mUserInfor.setCreateTime(TextUtil.TimeFormat(User.optLong("createTime")));
				}
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			Log.d(TAG, e.toString());
		}
		return mUserInfor;

	}*/


}
