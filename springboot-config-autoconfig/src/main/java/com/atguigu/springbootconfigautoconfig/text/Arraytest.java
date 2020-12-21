package com.atguigu.springbootconfigautoconfig.text;

import java.util.Arrays;

public class Arraytest {
     public static void main(String[] args) {
         int[] a=new int[]{89,54,14,79,11,78,987,45,16,71,100};
         for (int i=0;i<a.length;i++){
             System.out.print(" "+a[i]);
         }
         Arrays.sort(a);
         int result=100;
         int hand =0;
         int end =a.length-1;
         boolean index=false;
         while (hand<=end){
             int mod=(end+hand)/2;
             if (result==a[mod]){
                 System.out.println("位置"+mod);
                 index=true;
                 break;
             }else if (result<a[mod]){
                 end=mod;
             }else
             {hand=mod;}

             }
         if (!index){
             System.out.println("没有找到");
         }

         for (int  b: a){
             System.out.print(" "+b);
             System.out.println();
         }
    }
}
