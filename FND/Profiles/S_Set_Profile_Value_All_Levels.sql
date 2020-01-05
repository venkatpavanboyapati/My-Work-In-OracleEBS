--Set profile value at SITE Level

declare 
   v_check            boolean;
   v_profile_name varchar2(240) := 'HZ: Generate Party Number';
   v_profile           varchar2(240);
   v_value             varchar2(1)   := 'Y';
begin 
   --begin
   select profile_option_name
     into v_profile
     from fnd_profile_options_tl
    where language = 'US'
      and user_profile_option_name = v_profile_name ;
   --exception
   --end;
     
   v_check := fnd_profile.save( x_name                     => v_profile              
                                         , x_value                      => v_value
                                         , x_level_name             => 'SITE'              
                                         , x_level_value              => null              
                                         , x_level_value_app_id   => null) ; 
   if v_check then
      dbms_output.put_line('Profile '||v_profile_name||' updated with '||v_value);
      commit;
   else
      dbms_output.put_line('Error while updating Profile '||v_profile_name||' with value '||v_value);
   end if;
exception
   when others then
      dbms_output.put_line('Error: '||sqlerrm);
end;




 --Set profile value at Application Level

declare 
   v_check           boolean;
   v_profile_name varchar2(240) := 'HZ: Generate Party Number';
   v_profile           varchar2(240);
   v_value             varchar2(1)   := 'Y';
   v_appl_name    varchar2(4)   := 'AR';
   v_appl_id         number;
begin 
   --begin
   select profile_option_name
     into v_profile
     from fnd_profile_options_tl
    where language = 'US'
      and user_profile_option_name = v_profile_name ;
     
   select application_id
     into v_appl_id
     from fnd_application
    where application_short_name = 'AR';
    --exception
    --end;
     
   v_check := fnd_profile.save( x_name                     => v_profile              
                                         , x_value                      => v_value
                                         , x_level_name             => 'APPL'               
                                         , x_level_value              => v_appl_id              
                                         , x_level_value_app_id   => null) ; 
   if v_check then
      dbms_output.put_line('Profile '||v_profile_name||' updated with '||v_value);
      commit;
   else
      dbms_output.put_line('Error while updating Profile '||v_profile_name||' with value '||v_value);
   end if;
exception
   when others then
      dbms_output.put_line('Error: '||sqlerrm);
end;




 --Set profile value at Responsibility Level

declare 
   v_check            boolean;
   v_profile_name varchar2(240) := 'HZ: Generate Party Number';
   v_profile           varchar2(240);
   v_value             varchar2(1)   := 'Y';
   v_resp_name    varchar2(240)   := 'Purchasing Super User';
   v_resp_id         number;
   v_resp_app_id number;
begin 
   --begin
   select profile_option_name
     into v_profile
     from fnd_profile_options_tl
    where language = 'US'
      and user_profile_option_name = v_profile_name ;
     
    select responsibility_id      
         , application_id   
      into v_resp_id      
         , v_resp_app_id   
    from fnd_responsibility_tl  
    where responsibility_name = v_resp_name ;
    --exception
    --end;
     
   v_check := fnd_profile.save( x_name                     => v_profile              
                                         , x_value                      => v_value
                                         , x_level_name             => 'RESP'               
                                         , x_level_value              => v_resp_id             
                                         , x_level_value_app_id   => v_resp_app_id) ; 
   if v_check then
      dbms_output.put_line('Profile '||v_profile_name||' updated with '||v_value);
      commit;
   else
      dbms_output.put_line('Error while updating Profile '||v_profile_name||' with value '||v_value);
   end if;
exception
   when others then
      dbms_output.put_line('Error: '||sqlerrm);
end;




 --Set profile value at User Level

declare 
   v_check           boolean;
   v_profile_name varchar2(240) := 'HZ: Generate Party Number';
   v_profile           varchar2(240);
   v_value             varchar2(1)   := 'Y';
   v_user_name    varchar2(240)   := 'XX1234';
   v_user_id         number;
begin 
   --begin
   select profile_option_name
     into v_profile
     from fnd_profile_options_tl
    where language = 'US'
      and user_profile_option_name = v_profile_name ;
     
    select user_id       
      into v_user_id       
      from fnd_user  
     where user_name = v_user_name ;
    --exception
    --end;
     
   v_check := fnd_profile.save( x_name                     => v_profile              
                                         , x_value                      => v_value
                                         , x_level_name             => 'USER'               
                                         , x_level_value              => v_user_id             
                                         , x_level_value_app_id   => null) ; 
   if v_check then
      dbms_output.put_line('Profile '||v_profile_name||' updated with '||v_value);
      commit;
   else
      dbms_output.put_line('Error while updating Profile '||v_profile_name||' with value '||v_value);
   end if;
exception
   when others then
      dbms_output.put_line('Error: '||sqlerrm);
end;
