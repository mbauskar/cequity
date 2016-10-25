select 
u.uid as uid,
ifnull(u.name,"") as mobile,
ifnull(u.mail,"") as mail,
ifnull(cfn.field_customer_first_name_value,"") as firstname,
ifnull(cln.field_customer_last_name_value,"") as lastname,
sp.social_media as media,
sp.social_action as action , 
sp.social_points as points,
date_format(from_unixtime(sp.last_updated),"%d/%m/%Y %H:%i:%s") as date
from cequity.sp_storage_txn sp 
inner join cequity.users u on u.uid=sp.uid
inner join cequity.profile p on p.uid=u.uid 
inner join cequity.users_roles ur on ur.uid=u.uid 
left join cequity.field_data_field_customer_first_name cfn on cfn.entity_id=u.uid 
left join cequity.field_data_field_customer_last_name cln on cln.entity_id=u.uid
where ur.rid=8 and sp.social_action not  like "%manual social expire%" and 
date(from_unixtime(sp.last_updated)) = date_format("{report_date}","%Y-%m-%d")
