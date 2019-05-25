/**
 * @author ZhouTanPing E-mail:strong.ping@foxmail.com 
 * @version 创建时间：2015-9-22 下午7:09:08 
 */
package com.sun3d.ticketGdfs.adapter;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.entity.CodeButtonEntity;

import java.util.List;

/**
 * @author zhoutanping 活动验证（座位）的adapter
 *
 */
public class ActivitySeatAdapter extends BaseAdapter {

    private String TAG = "ActivitySeatAdapter";
    private LayoutInflater inflater;
    private List<CodeButtonEntity> codeEntity;
    private Context context;

    public ActivitySeatAdapter(Context mContext,
                               List<CodeButtonEntity> codeEntity) {
        context = mContext;
        this.codeEntity = codeEntity;
        this.inflater = LayoutInflater.from(mContext);
        for (int i = 0; i < codeEntity.size(); i++) {
            Log.i(TAG, codeEntity.get(i).toString());
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see android.widget.Adapter#getCount()
     */
    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return codeEntity.size();
    }

    public void setData(List<CodeButtonEntity> entity){
        this.codeEntity.clear();
        this.codeEntity.addAll(entity);
        this.notifyDataSetChanged();
    }

    /*
     * (non-Javadoc)
     *
     * @see android.widget.Adapter#getItem(int)
     */
    @Override
    public CodeButtonEntity getItem(int arg0) {
        // TODO Auto-generated method stub
        return codeEntity.get(arg0);
    }

    /*
     * (non-Javadoc)
     *
     * @see android.widget.Adapter#getItemId(int)
     */
    @Override
    public long getItemId(int arg0) {
        // TODO Auto-generated method stub
        return 0;
    }
    /*
     * (non-Javadoc)
     *
     * @see android.widget.Adapter#getView(int, android.view.View,
     * android.view.ViewGroup)
     */
    @Override
    public View getView(final int arg0, View view, ViewGroup arg2) {
        // TODO Auto-generated method stub
        //		if (view == null) {
        view = inflater.inflate(R.layout.item_ticket_adapter, null);
//		}

        final TextView tt = (TextView) view.findViewById(R.id.item_ticket);

        if (("票").equals(codeEntity.get(arg0).getShowSeat())){
            tt.setVisibility(View.GONE);
        }else {
            if (null!=codeEntity.get(arg0).getShowSeat()){
                tt.setText(codeEntity.get(arg0).getShowSeat());
            }else {
                tt.setText("");
                tt.setBackgroundResource(R.drawable.shape_input_tiem);
                tt.setEnabled(false);
            }

        }
        if (!codeEntity.get(arg0).getTotalState().equals("7")) {

            if (codeEntity.get(arg0).getState().equals("7")) {
                tt.setBackgroundResource(R.drawable.shape_input_tiem_click);
            } else {
                tt.setBackgroundResource(R.drawable.shape_input_tiem);
            }

            if (!codeEntity.get(arg0).getState().equals("7")) {

                tt.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View view) {
                        // TODO Auto-generated method stub
                        Log.i(TAG, arg0 + "----" + codeEntity.toString());
                        if(arg0 <= getCount())
                            if (codeEntity.get(arg0).getState().equals("7")) {
                                codeEntity.get(arg0).setState(
                                        codeEntity.get(arg0).getMinorState());
                                tt.setTextColor(context.getResources().getColor(R.color.black));
                                tt.setBackgroundResource(R.drawable.shape_input_tiem);
                            } else {
                                Log.i(TAG, codeEntity.toString());
                                codeEntity.get(arg0).setState("7");
                                tt.setTextColor(context.getResources().getColor(R.color.white));
                                tt.setBackgroundResource(R.drawable.shape_input_tiem_click);
                            }
                    }
                });
            }
        }else{
            tt.setBackgroundResource(R.drawable.shape_input_tiem_click);
        }
        if (MyApplication.isSelectActivity == 1){
            tt.setClickable(false);
        }
        Log.i(TAG, arg0 + "-------" + tt.getText());
        return view;
    }




    class Holder{
        TextView text;
    }

}
