package com.sun3d.ticketGdfs.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.Util.Constants.CODE_STATE;
import com.sun3d.ticketGdfs.Util.JsonUtil;
import com.sun3d.ticketGdfs.Util.NetworkHttp;
import com.sun3d.ticketGdfs.Util.ToastUtil;
import com.sun3d.ticketGdfs.Util.WindowsUtil;
import com.sun3d.ticketGdfs.adapter.ActivitySeatAdapter;
import com.sun3d.ticketGdfs.adapter.MyViewHolder;
import com.sun3d.ticketGdfs.adapter.VenueRoomInfoAdapter;
import com.sun3d.ticketGdfs.entity.CodeButtonEntity;
import com.sun3d.ticketGdfs.entity.VenueCodeButtonEntity;
import com.sun3d.ticketGdfs.entity.VeriVenueInfo;
import com.sun3d.ticketGdfs.entity.VerificationInfo;
import com.sun3d.ticketGdfs.http.HttpCode;
import com.sun3d.ticketGdfs.http.HttpRequestCallback;
import com.sun3d.ticketGdfs.http.HttpUrlList;
import com.sun3d.ticketGdfs.http.MyHttpRequest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 确认验票页面（扫码或登录（点击输入验证码）都可进入本界面）
 */
public class SelectInputCodeActivity extends Activity implements OnClickListener, AdapterView.OnItemClickListener {

    private String TAG = "InputCodeActivity";
    private EditText mCodeContent = null;
    private Button mInputConfirm = null;
    private Context mContext = null;

    private Button mCodeOk = null; // 确认按钮
    private ImageView mConfirmInfo = null; // 验证图片

    private RelativeLayout mCodeInfo;
    private String ticketCode = ""; // 取票码

    private ProgressDialog mProgress;

    private VeriVenueInfo mVenue;
    private VerificationInfo mVeri;
    private GridView seatGrid;
    private Button seat, seats, seat2;
    private String orderIds;
    private String BookStatus;
    // 所有的座位
    private List<CodeButtonEntity> codeEntity;
    private List<VenueCodeButtonEntity> venueCodeEntity;
    private VenueCodeButtonEntity venueVeriInfo;

    private ActivitySeatAdapter seatAdapter;
    private VenueRoomInfoAdapter mVenueRoomInfoAdapter;

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MyViewHolder viewHolder = (MyViewHolder) view.getTag();
        viewHolder.date.toggle();
        VenueRoomInfoAdapter.init();
        VenueRoomInfoAdapter.isSelected.put(position, viewHolder.date.isChecked());
        List<VenueCodeButtonEntity> venueCodeButtonEntityList = VenueRoomInfoAdapter.listItems;

//        venueVeriInfo.setBookStatus(venueCodeButtonEntityList.get(position).getBookStatus());
        if (venueCodeButtonEntityList.get(position).getBookStatus().equals("1")
                || venueCodeButtonEntityList.get(position).getBookStatus().equals("4")) {
            orderIds = venueCodeButtonEntityList.get(position).getOrderIds();
            BookStatus = venueCodeButtonEntityList.get(position).getBookStatus();
        }
        if (!viewHolder.date.isChecked()) {
            orderIds = null;
        }
        Log.d("bookid", orderIds + "-----------" + venueCodeButtonEntityList.get(position).getBookStatus());
        mVenueRoomInfoAdapter.notifyDataSetChanged();
    }

    /**
     * 初始活动室信息
     * wmm
     *
     * @param venueCodeEntity
     */
    public void initVenueRoomInfo(VeriVenueInfo mVenue, List<VenueCodeButtonEntity> venueCodeEntity) {
        mCodeInfo.removeAllViewsInLayout();
        RelativeLayout venueInfo = (RelativeLayout) getLayoutInflater()
                .inflate(R.layout.input_code_venue_info, null);
        mCodeInfo.addView(venueInfo);
        mCodeOk = (Button) mCodeInfo.findViewById(R.id.input_code_ok);
        mCodeOk.setVisibility(View.GONE);
        ListView mListView = (ListView) mCodeInfo.findViewById(R.id.input_code_venue_info_listview);
        //订单编号
        ((TextView) mCodeInfo.findViewById(R.id.input_code_venue_info_num)).setText(mVenue.getRoomOrderNo());
        //场馆名称
        ((TextView) mCodeInfo.findViewById(R.id.input_code_venue_info_name)).setText(mVenue.getVenueName());
        //取票码
        ((TextView) mCodeInfo.findViewById(R.id.input_code_venue_info_ticket_code)).setText(mVenue.getValidCode());
        //订单编号
        ((TextView) mCodeInfo.findViewById(R.id.input_code_venue_info_tram_name)).setText(mVenue.getTuserTeamName());
        //手机号
        ((TextView) mCodeInfo.findViewById(R.id.input_code_venue_info_tram_phone)).setText(mVenue.getOrderTel());
        //总订单状态（已隐藏）
        TextView state = (TextView) mCodeInfo.findViewById(R.id.code_venue_verification);
        state.setVisibility(View.GONE);
        mVenueRoomInfoAdapter = new VenueRoomInfoAdapter(SelectInputCodeActivity.this, venueCodeEntity, R.layout.item_venue);
        mListView.setOnItemClickListener(this);

        mListView.setAdapter(mVenueRoomInfoAdapter);
    }

    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            // TODO Auto-generated method stub
            switch (msg.what) {
                case CODE_STATE.ACTIVITY_SUCCESS:
                    cancelDialog();
                    mCodeInfo.setVisibility(View.VISIBLE);
                    mVeri = (VerificationInfo) msg.obj;
                    setInitActivity(mVeri);
                    break;
                case CODE_STATE.VENUE_SUCCESS:
                    cancelDialog();
                    mCodeInfo.setVisibility(View.VISIBLE);
                    mVenue = (VeriVenueInfo) msg.obj;
                    myVenueAnalytical(mVenue);
//                    setInitVenue(mVenue);
                    initVenueRoomInfo(mVenue, venueCodeEntity);
                    break;
                default:
                    break;
            }

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        MyApplication.isSelectActivity = 1;
        setContentView(R.layout.activity_input_code);
        MyApplication.addActivitys(this);
        mContext = this;
        initIntent();
        codeEntity = new ArrayList<CodeButtonEntity>();
        venueCodeEntity = new ArrayList<VenueCodeButtonEntity>();
        venueVeriInfo = new VenueCodeButtonEntity();
        initView();
    }

    @Override
    protected void onStart() {
        // TODO Auto-generated method stub
        super.onStart();
    }

    private void initIntent() {
        // TODO Auto-generated method stub
        String ticketCode = getIntent().getStringExtra("ticketCode");
        if (ticketCode != null && !ticketCode.equals("")) {
            this.ticketCode = ticketCode;
        }
    }

    private void initView() {
        // TODO Auto-generated method stub
        initDialog();
        RelativeLayout mTitle = (RelativeLayout) findViewById(R.id.main_input_code);
        ImageView mTitleLeft = (ImageView) mTitle
                .findViewById(R.id.title_left);
        TextView mTitleContent = (TextView) mTitle
                .findViewById(R.id.title_content);
        mTitleContent.setText(R.string.select_input_code_title);
        mTitleLeft.setImageResource(R.drawable.sh_icon_return);
        mCodeContent = (EditText) findViewById(R.id.input_frame);
        mInputConfirm = (Button) findViewById(R.id.input_confirm);
        this.mCodeInfo = (RelativeLayout) findViewById(R.id.main_input_code_info);

        if (MyApplication.mVerificationType == CODE_STATE.VENUE_VERIFICATION) {
            mCodeInfo.removeAllViewsInLayout();
            RelativeLayout venueInfo = (RelativeLayout) getLayoutInflater()
                    .inflate(R.layout.venue_code_info, null);
            mCodeInfo.addView(venueInfo);
        }

        mCodeInfo.setVisibility(View.INVISIBLE);

        mCodeOk = (Button) mCodeInfo.findViewById(R.id.input_code_ok);

        mCodeOk.setVisibility(View.GONE);

        mConfirmInfo = (ImageView) mCodeInfo
                .findViewById(R.id.confirm_code_anim);
        mInputConfirm.setOnClickListener(this);
        mTitleLeft.setOnClickListener(this);

        if (!ticketCode.equals("")) {
            mCodeContent.setText(ticketCode);
            getActivityInfo();
//            if (MyApplication.mVerificationType == CODE_STATE.ACTIVITY_VERIFICATION) {
//                getActivityInfo();
//            } else {
//                getVenueInfo();
//            }
        }
    }

    /**
     * 活动初始化值
     */
    public void setInitActivity(VerificationInfo mVeri) {
        mCodeInfo.removeAllViewsInLayout();
        RelativeLayout venueInfo = (RelativeLayout) getLayoutInflater()
                .inflate(R.layout.input_code_info, null);
        mCodeInfo.addView(venueInfo);
        mCodeOk = (Button) mCodeInfo.findViewById(R.id.input_code_ok);
        mCodeOk.setVisibility(View.GONE);
        mConfirmInfo = (ImageView) mCodeInfo.findViewById(R.id.confirm_code_anim);
//		mCodeInfo.setVisibility(View.VISIBLE);
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_content))
                .setText(mVeri.getOrderNumber());

        TextView state = (TextView) mCodeInfo.findViewById(R.id.code_info_verification);

        //（总订单状态）1:暂无，2:已预订，3:暂无，4:暂无，5:已退订，6:已出票，7:已入场
        switch (mVeri.getState()) {
            case "1":
                state.setText("状态：" + "");
                break;
            case "2":
                state.setText("状态：" + "已预订");
                break;
            case "3":
                state.setText("状态：" + "");
                break;
            case "4":
                state.setText("状态：" + "");
                break;
            case "5":
                state.setText("状态：" + "已退订");
                break;
            case "6":
                state.setText("状态：" + "已出票");
                break;
            case "7":
                state.setText("状态：" + "已入场");
                break;
            case "8":
                state.setText("状态：" + "未入场");
                break;
            default:
                state.setText("状态：" + "获取失败");
                break;
        }
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_activity))
                .setText(mVeri.getActivityTitle());
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_address))
                .setText(mVeri.getAddress());
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_screenings))
                .setText(mVeri.getScreenings());
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_number))
                .setText(mVeri.getNumber());
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_ticket))
                .setText(mVeri.getTicketCode());
        ((TextView) mCodeInfo.findViewById(R.id.code_info_order_phone))
                .setText(mVeri.getPhoneNumber());
        seatGrid = (GridView) mCodeInfo
                .findViewById(R.id.tv_mylist_item_seat_tab);
        initSeat(mVeri, seatGrid);
    }

    @Override
    public void onClick(View view) {
        // TODO Auto-generated method stub
        Intent intent = null;
        switch (view.getId()) {
            case R.id.title_left:
                cleanData();
                SelectInputCodeActivity.this.finish();
                break;
            case R.id.input_confirm:// 查询
                WindowsUtil.HideKeyboard(view);
                initDialog();
                cleanData();
                veriControlInit();
                String codeContent = mCodeContent.getText().toString();
                if (codeContent != null && !codeContent.equals("")) {
                    this.ticketCode = codeContent;
                    if (!NetworkHttp.isNetworkConnected(mContext)) {
                        return;
                    }
                    getActivityInfo();
                } else {
                    Toast.makeText(getApplicationContext(), "请先输入取票码！",
                            Toast.LENGTH_LONG).show();
                }
                break;
            default:
                break;
        }
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
    }

    /*
     * 活动验证获取票据信息 *
     */
    public void getActivityInfo() {
        initDialog();
        mProgress.setMessage("正在加载信息···");
        mProgress.show();
        Log.i(TAG, "code:"+ticketCode);
        Map<String, String> mParams = new HashMap<String, String>();
        mParams.put(HttpUrlList.AllParameter.VALIDATE_CODE, ticketCode);
        MyHttpRequest.onStartHttpGET(HttpUrlList.SelectUrl.SELECT,
                mParams, new HttpRequestCallback() {

                    @Override
                    public void onPostExecute(int statusCode, String resultStr) {
                        // TODO Auto-generated method stub
                        Message msg = handler.obtainMessage();

                        if (statusCode != HttpCode.HTTP_Request_Success_CODE) {
                            ToastUtil.showToast("网络链接异常！");
                            cancelDialog();
                            return;
                        }
                        String type = JsonUtil.isSelect(resultStr);
                        Log.i(TAG,"type:  "+type);
                        switch (type) {
                            case "1":
                                VerificationInfo mVeri = JsonUtil
                                        .getActivityVeri(resultStr);
                                if (JsonUtil.status.equals(HttpCode.serverCode.DATA_Success_CODE)) {
                                    if (mVeri != null) {
                                        msg.what = CODE_STATE.ACTIVITY_SUCCESS;
                                        msg.obj = mVeri;
                                        handler.sendMessage(msg);
                                    } else {
//                                Toast.makeText(mContext, "验证出错!",
//                                        Toast.LENGTH_LONG).show();
                                    }
                                } else {
                                    ToastUtil.showToast(JsonUtil.JsonMSG);
                                }
                                break;
                            case "2":
                                VeriVenueInfo mVenue = JsonUtil
                                        .getVeriVenueInfo(resultStr);
                                Log.d("resultStr------", JsonUtil.JsonMSG);
                                if (JsonUtil.status.equals(HttpCode.serverCode.DATA_Success_CODE)) {
                                    if (mVenue != null) {
                                        msg.what = CODE_STATE.VENUE_SUCCESS;
                                        msg.obj = mVenue;
                                        handler.sendMessage(msg);
                                    } else {
                                        Toast.makeText(mContext, "验证出错!",
                                                Toast.LENGTH_LONG).show();
                                    }
                                } else {
                                    ToastUtil.showToast(JsonUtil.JsonMSG);
                                }
                                break;
                            default:
                                if (mCodeInfo.getVisibility() == View.VISIBLE) {
                                    mCodeInfo.setVisibility(View.INVISIBLE);
                                }
                                ToastUtil.showToast(JsonUtil.JsonMSG);
                                break;
                        }
                        cancelDialog();
                    }
                });
    }

    /**
     * 动态添加，座位Button
     */
    public void initSeat(VerificationInfo mVeri, GridView gridSeat) {
        myAnalytical(mVeri);
        seatAdapter = new ActivitySeatAdapter(this, codeEntity);
        gridSeat.setEnabled(false);
        gridSeat.setAdapter(seatAdapter);

    }

    /**
     * 将座位转成（如：1排1座）
     */
    public void myAnalytical(VerificationInfo mVeri) {
        String[] leng = mVeri.getSeat().split(",");
        String[] stats = mVeri.getSeatStatus().split(",");
        CodeButtonEntity codeInfo;
        for (int i = 0; i < leng.length; i++) {
            codeInfo = new CodeButtonEntity();
            codeInfo.setSeat(leng[i]);
            if (leng[i].indexOf("_") != -1) {
                codeInfo.setShowSeat(leng[i].replaceAll("_", "排") + "座");
            } else {
                switch (leng[i]) {
                    case "1":
                        codeInfo.setShowSeat("票" + "A");
                        break;
                    case "2":
                        codeInfo.setShowSeat("票" + "B");
                        break;
                    case "3":
                        codeInfo.setShowSeat("票" + "C");
                        break;
                }
            }
            codeInfo.setState(stats[i]);
            codeInfo.setMinorState(stats[i]);
            codeInfo.setTotalState(mVeri.getState());
            codeEntity.add(codeInfo);

            Log.i(TAG, "---"+codeInfo.toString());
        }
    }

    /**
     * 活动室验票，数据解析
     */
    public void myVenueAnalytical(VeriVenueInfo venue) {
        cleanData();
        String[] nameT = venue.getRoomName().split(",");
        String[] orderidsT = venue.getOrderIds().split(",");
        String[] dateT = venue.getCurDate().split(",");
        String[] periodT = venue.getOpenPeriod().split(",");
        String[] statusT = venue.getBookStatus().split(",");
        venueCodeEntity.clear();
        for (int i = 0; i < orderidsT.length; i++) {
            VenueCodeButtonEntity vcbe = new VenueCodeButtonEntity();
            if (nameT.length > 0) {
                vcbe.setRoomNames(nameT[i]);
            }
            if (orderidsT.length > 0) {
                vcbe.setOrderIds(orderidsT[i]);
            }
            if (dateT.length > 0) {
                vcbe.setCurDates(dateT[i]);
            }
            if (periodT.length > 0) {
                vcbe.setOpenPeriods(periodT[i]);
            }
            if (dateT.length > 0) {
                vcbe.setCurDates(dateT[i]);
            }
            if (statusT.length > 0) {
                vcbe.setBookStatus(statusT[i]);
            }
            if (statusT.length > 0) {
                vcbe.setMinorState(statusT[i]);
            }
            venueCodeEntity.add(vcbe);
        }
    }

    /**
     * 查询前验证控件初始化
     */
    public void veriControlInit() {
        mCodeOk.setVisibility(View.GONE);
        mConfirmInfo.setVisibility(View.GONE);
    }

    /**
     * 关闭加载
     */
    public void cancelDialog() {
        if (mProgress != null) {
            mProgress.dismiss();
            mProgress = null;
        }
    }

    /**
     * 初始化Dialog
     */
    public void initDialog() {

        if (mProgress == null) {
            mProgress = new ProgressDialog(this);
            mProgress.setTitle("");
            // mProgress.setMessage("登录中请稍后···");
            // 设置在激活状态不可点击关闭
            mProgress.setCancelable(false);
            // 设置在按下返回键的时候关闭对话框
            mProgress.setOnKeyListener(new OnKeyListener() {
                @Override
                public boolean onKey(DialogInterface dialog, int keyCode,
                                     KeyEvent event) {
                    if (keyCode == KeyEvent.KEYCODE_BACK) {
                        mProgress.dismiss();
                    }
                    return false;
                }
            });
        }
    }

    public void cleanData() {
        venueVeriInfo = null;

        venueCodeEntity = new ArrayList<VenueCodeButtonEntity>();
        codeEntity = new ArrayList<CodeButtonEntity>();
        venueCodeEntity.clear();
        codeEntity.clear();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // TODO Auto-generated method stub
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            cleanData();
            SelectInputCodeActivity.this.finish();
        }
        return super.onKeyDown(keyCode, event);
    }


}
