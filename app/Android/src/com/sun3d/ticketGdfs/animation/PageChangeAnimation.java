package com.sun3d.ticketGdfs.animation;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.LayoutTransition;
import android.animation.ObjectAnimator;
import android.animation.PropertyValuesHolder;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.os.Build;
import android.view.View;
import android.widget.LinearLayout;

public class PageChangeAnimation {
	private LayoutTransition mTransitioner;
	private ContainerAnimation mMyAlphaAnimation;
	public int animaTime = 200;

	/**
	 * 容器内部显示（淡入，下滑出去），隐藏（淡出，上滑出去），动画
	 * 
	 * @param container父容�?
	 */
	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@SuppressLint("NewApi")
	public void alphaTranslationXAnimation(LinearLayout container) {
		mTransitioner = new LayoutTransition();
		mTransitioner.setDuration(animaTime);
		container.setLayoutTransition(mTransitioner);
		// Adding定义动画
		PropertyValuesHolder pvhXadd = PropertyValuesHolder.ofFloat("alpha", 0f, 1f);
		PropertyValuesHolder pvhYadd = PropertyValuesHolder.ofFloat("translationX", 600, 1f);
		// 动画：APPEARING
		// Adding
		ObjectAnimator animIn = ObjectAnimator.ofPropertyValuesHolder(this, pvhXadd, pvhYadd);
		mTransitioner.setAnimator(LayoutTransition.APPEARING, animIn);
		animIn.addListener(new AnimatorListenerAdapter() {
			public void onAnimationEnd(Animator anim) {
				View view = (View) ((ObjectAnimator) anim).getTarget();
				view.setAlpha(1);
			}
		});
		// Removing 定义动画
		PropertyValuesHolder pvhX = PropertyValuesHolder.ofFloat("alpha", 1f, 0f);
		PropertyValuesHolder pvhY = PropertyValuesHolder.ofFloat("translationX", 1f, -600);
		// 动画：DISAPPEARING
		// Removing
		ObjectAnimator animOut = ObjectAnimator.ofPropertyValuesHolder(mMyAlphaAnimation, pvhX,
				pvhY);
		mTransitioner.setAnimator(LayoutTransition.DISAPPEARING, animOut);

		animOut.addListener(new AnimatorListenerAdapter() {
			public void onAnimationEnd(Animator anim) {
				View view = (View) ((ObjectAnimator) anim).getTarget();
				view.setAlpha(0);
			}
		});

	}

}
