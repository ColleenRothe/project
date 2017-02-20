package teammsu.colleenrothe.usmp;

/**
 * Created by colleenrothe on 1/17/17.
 */

public class Maintenance extends Object {
    private int id;
    private int site_id;
    private String code_relation;
    private int maintenance_type;
    private String rt_num; //int?
    private String begin_mile; //int?
    private String end_mile; //int?
    private int agency;
    private int regional;
    private int local;
    private int us_event;
    private String event_desc;
    private int total;

    private int p1;
    private int p2;
    private int p3;
    private int p4;
    private int p4_5;
    private int p5;
    private int p6;
    private int p7;
    private int p8;
    private int p9;
    private int p10;
    private int p11;
    private int p12;
    private int p13;
    private int p14;
    private int p15;
    private int p16;
    private int p17;
    private int p18;
    private int p19;
    private int p20;

    private String others1_desc;
    private String others2_desc;
    private String others3_desc;
    private String others4_desc;
    private String others5_desc;
    private int total_percent;

    public Maintenance(){

    }

    public Maintenance(int id, int site_id, String code_relation, int maintenance_type, String rt_num ,
                       String begin_mile, String end_mile, int agency, int regional, int local, int us_event,
                       String event_desc, int total, int p1, int p2,int p3,int p4,int p4_5,int p5,int p6,int p7,
                       int p8,int p9,int p10,int p11,int p12,int p13,int p14,int p15,int p16,int p17,int p18,
                       int p19,int p20, String others1_desc, String others2_desc, String others3_desc,
                       String others4_desc, String others5_desc, int total_percent){
        this.id = id;
        this.site_id=site_id;
        this.code_relation=code_relation;
        this.maintenance_type=maintenance_type;
        this.rt_num=rt_num;
        this.begin_mile=begin_mile;
        this.end_mile=end_mile;
        this.agency=agency;
        this.regional=regional;
        this.local=local;
        this.us_event=us_event;
        this.event_desc=event_desc;
        this.total = total;
        this.p1=p1;
        this.p2=p2;
        this.p3=p3;
        this.p4=p4;
        this.p4_5=p4_5;
        this.p5=p5;
        this.p6=p6;
        this.p7=p7;
        this.p8=p8;
        this.p9=p9;
        this.p10=p10;
        this.p11=p11;
        this.p12=p12;
        this.p13=p13;
        this.p14=p14;
        this.p15=p15;
        this.p16=p16;
        this.p17=p17;
        this.p18=p18;
        this.p19=p19;
        this.p20=p20;
        this.others1_desc = others1_desc;
        this.others2_desc = others2_desc;
        this.others3_desc = others3_desc;
        this.others4_desc = others4_desc;
        this.others5_desc = others5_desc;
        this.total_percent=total_percent;



    }

    public Maintenance(int site_id, String code_relation, int maintenance_type, String rt_num ,
                       String begin_mile, String end_mile, int agency, int regional, int local, int us_event,
                       String event_desc, int total, int p1, int p2,int p3,int p4,int p4_5,int p5,int p6,int p7,
                       int p8,int p9,int p10,int p11,int p12,int p13,int p14,int p15,int p16,int p17,int p18,
                       int p19,int p20, String others1_desc, String others2_desc, String others3_desc,
                       String others4_desc, String others5_desc,int total_percent){

        this.site_id=site_id;
        this.code_relation=code_relation;
        this.maintenance_type=maintenance_type;
        this.rt_num=rt_num;
        this.begin_mile=begin_mile;
        this.end_mile=end_mile;
        this.agency=agency;
        this.regional=regional;
        this.local=local;
        this.us_event=us_event;
        this.event_desc=event_desc;
        this.total = total;
        this.p1=p1;
        this.p2=p2;
        this.p3=p3;
        this.p4=p4;
        this.p4_5=p4_5;
        this.p5=p5;
        this.p6=p6;
        this.p7=p7;
        this.p8=p8;
        this.p9=p9;
        this.p10=p10;
        this.p11=p11;
        this.p12=p12;
        this.p13=p13;
        this.p14=p14;
        this.p15=p15;
        this.p16=p16;
        this.p17=p17;
        this.p18=p18;
        this.p19=p19;
        this.p20=p20;
        this.others1_desc = others1_desc;
        this.others2_desc = others2_desc;
        this.others3_desc = others3_desc;
        this.others4_desc = others4_desc;
        this.others5_desc = others5_desc;
        this.total_percent=total_percent;

    }

    public int getID(){return id;}
    public void setID(int id){this.id=id;}

    public int getSite_id(){return site_id;}
    public void setSite_id(int site_id){this.site_id=site_id;}

    public String getCode_relation(){return code_relation;}
    public void setCode_relation(String code_relation){this.code_relation=code_relation;}

    public int getMaintenance_type(){return maintenance_type;}
    public void setMaintenance_type(int maintenance_type){this.maintenance_type=maintenance_type;}

    public String getRt_num(){return rt_num;}
    public void setRt_num(String rt_num){this.rt_num=rt_num;}

    public String getBegin_mile(){return begin_mile;}
    public void setBegin_mile(String begin_mile){this.begin_mile=begin_mile;}

    public String getEnd_mile(){return end_mile;}
    public void setEnd_mile(String end_mile){this.end_mile=end_mile;}

    public int getAgency(){return agency;}
    public void setAgency(int agency){this.agency=agency;}

    public int getRegional(){return regional;}
    public void setRegional(int regional){this.regional=regional;}

    public int getLocal(){return local;}
    public void setLocal(int local){this.local=local;}

    public int getUs_event(){return us_event;}
    public void setUs_event(int us_event){this.us_event=us_event;}

    public String getEvent_desc(){return event_desc;}
    public void setEvent_desc(String event_desc){this.event_desc=event_desc;}

    public int getTotal(){return total;}
    public void setTotal(int total){this.total=total;}

    public int getP1(){return p1;}
    public void setP1(int p1){this.p1=p1;}

    public int getP2(){return p2;}
    public void setP2(int p2){this.p2=p2;}

    public int getP3(){return p3;}
    public void setP3(int p3){this.p3=p3;}

    public int getP4(){return p4;}
    public void setP4(int p4){this.p4=p4;}

    public int getP4_5(){return p4_5;}
    public void setP4_5(int p4_5){this.p4_5=p4_5;}

    public int getP5(){return p5;}
    public void setP5(int p5){this.p5=p5;}

    public int getP6(){return p6;}
    public void setP6(int p6){this.p6=p6;}

    public int getP7(){return p7;}
    public void setP7(int p7){this.p7=p7;}

    public int getP8(){return p8;}
    public void setP8(int p8){this.p8=p8;}

    public int getP9(){return p9;}
    public void setP9(int p9){this.p9=p9;}

    public int getP10(){return p10;}
    public void setP10(int p10){this.p10=p10;}

    public int getP11(){return p11;}
    public void setP11(int p11){this.p11=p11;}

    public int getP12(){return p12;}
    public void setP12(int p12){this.p12=p12;}

    public int getP13(){return p13;}
    public void setP13(int p13){this.p13=p13;}

    public int getP14(){return p14;}
    public void setP14(int p14){this.p14=p14;}

    public int getP15(){return p15;}
    public void setP15(int p15){this.p15=p15;}

    public int getP16(){return p16;}
    public void setP16(int p16){this.p16=p16;}

    public int getP17(){return p17;}
    public void setP17(int p17){this.p17=p17;}

    public int getP18(){return p18;}
    public void setP18(int p18){this.p18=p18;}

    public int getP19(){return p19;}
    public void setP19(int p19){this.p19=p19;}

    public int getP20(){return p20;}
    public void setP20(int p20){this.p20=p20;}

    public String getOthers1_desc(){return others1_desc;}
    public void setOthers1_desc(String others1_desc){this.others1_desc=others1_desc;}

    public String getOthers2_desc(){return others2_desc;}
    public void setOthers2_desc(String others2_desc){this.others2_desc=others2_desc;}

    public String getOthers3_desc(){return others3_desc;}
    public void setOthers3_desc(String others3_desc){this.others3_desc=others3_desc;}

    public String getOthers4_desc(){return others4_desc;}
    public void setOthers4_desc(String others4_desc){this.others4_desc=others4_desc;}

    public String getOthers5_desc(){return others5_desc;}
    public void setOthers5_desc(String others5_desc){this.others5_desc=others5_desc;}

    public int getTotal_percent(){return total_percent;}
    public void setTotal_percent(int total_percent){this.total_percent=total_percent;}


}
