/**
 * Created by rsieve on 8/22/17.
 */

public with sharing class NewPageCon {

    public Apexpages.StandardController con;
    public NewPageCon(Apexpages.Standardcontroller con){
        this.con = con;
    }

    public string getCurrentTime(){
        return string.valueOf(system.now());
    }

    public string getUserId(){
        system.debug(userinfo.getUserId());
        return userinfo.getUserId();
    }


}