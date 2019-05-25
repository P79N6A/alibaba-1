package com.sun3d.ticketGdfs.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.entity.VenueCodeButtonEntity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 活动室列表适配器
 * Created by wangmingming on 2015/10/29.
 */
public class VenueRoomInfoAdapter extends BaseAdapter {
    public static HashMap<Integer, Boolean> isSelected;
    public static HashMap<Integer, String> isbooked;
    private Context context;
    public static List<VenueCodeButtonEntity> listItems;
    private LayoutInflater listContainer;
    private int itemViewResource;
    private MyViewHolder listItemView = null;
    private Map<Integer, View> map = new HashMap<Integer, View>();

    public VenueRoomInfoAdapter(Context context, List<VenueCodeButtonEntity> data, int resource) {
        this.context = context;
        this.listContainer = LayoutInflater.from(context);
        this.itemViewResource = resource;
        this.listItems = data;
        init();
    }


    public void setDatas(List<VenueCodeButtonEntity> datas){
        listItems.clear();
        listItems.addAll(datas);
        notifyDataSetChanged();
    }


    // 初始化 设置所有checkbox都为未选择
    public static void init() {
        isSelected = new HashMap<Integer, Boolean>();
        isbooked = new HashMap<Integer, String>();
        for (int i = 0; i < listItems.size(); i++) {
//            if(listItems.get(i).getBookStatus().equals("5")){
//                isbooked.put(i,false);
//            }else {
//                isbooked.put(i,true);
//            }
            isSelected.put(i, false);
        }
    }

    @Override
    public int getCount() {
        return listItems.size();
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return null;
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return 0;
    }

    public void setisAdmission(String isAdmission) {
        listItemView.isAdmission.setVisibility(View.VISIBLE);
        listItemView.isAdmission.setText(isAdmission);
        listItemView.date.setEnabled(false);
        listItemView.date.setBackgroundResource(R.drawable.shape_input_tiem_click);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = listContainer.inflate(this.itemViewResource, null);
            listItemView = new MyViewHolder();
            listItemView.name = (TextView) convertView.findViewById(R.id.item_venue_name);
            listItemView.date = (CheckBox) convertView.findViewById(R.id.item_venue_date);
            listItemView.isAdmission = (TextView) convertView.findViewById(R.id.isAdmission);
            convertView.setTag(listItemView);
        } else {
            listItemView = (MyViewHolder) convertView.getTag();
        }
        VenueCodeButtonEntity venueRoomEntity = listItems.get(position);
        listItemView.name.setText(venueRoomEntity.getRoomNames());
        listItemView.date.setText(" " + venueRoomEntity.getOpenPeriods());//6.27 link修改
//        listItemView.date.setText(venueRoomEntity.getCurDates() + " " + venueRoomEntity.getOpenPeriods());

        //5:已验票，7：未入场
        String state = listItems.get(position).getBookStatus();
        switch (state) {
            case "1":
                listItemView.isAdmission.setText("已预订");
                listItemView.isAdmission.setVisibility(View.VISIBLE);
                listItemView.date.setEnabled(true);
                listItemView.date.setBackgroundResource(R.drawable.checkbox_style);
                break;
            case "2":
                setisAdmission("已退订");
                break;
            case "3":
                setisAdmission("预定失败");
                break;
            case "4":
                listItemView.isAdmission.setText("已出票");
                listItemView.isAdmission.setVisibility(View.VISIBLE);
                listItemView.date.setEnabled(true);
                listItemView.date.setBackgroundResource(R.drawable.checkbox_style);
                break;
            case "5":
                setisAdmission("已入场");
                break;
            case "7":
                setisAdmission("未入场");
                break;
            default:
                listItemView.isAdmission.setVisibility(View.GONE);
                listItemView.date.setEnabled(true);
                listItemView.date.setBackgroundResource(R.drawable.checkbox_style);
                break;
        }
        listItemView.date.setChecked(isSelected.get(position));
        if (MyApplication.isSelectActivity == 1) {
            listItemView.date.setChecked(false);
        }
        //全部设置不可选
        listItemView.date.setChecked(false);
        listItemView.isAdmission.setVisibility(View.GONE);
        return convertView;
    }

}
