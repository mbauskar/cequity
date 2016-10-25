select u.uid as uid,
"" as "Customer ID as per Celio",
ifnull(u.name,"") as mobile,
ifnull(u.mail,"") as Mail,
ifnull(cfn.field_customer_first_name_value,"") as Firstname,
ifnull(cln.field_customer_last_name_value,"") as Lastname,
ifnull((select sum(points) from cequity.userpoints_txn txn where txn.uid=u.uid and txn.description 
like "%Points added by order%"),0) as " Total Purchase Points",
ifnull((select spt.max_spoints from cequity.sp_storage_total spt where spt.uid=u.uid ),0) as " Total Social Points",
ifnull((select sum(abs(points)) from cequity.userpoints_txn txn where txn.uid=u.uid and txn.description 
like "%Points redeemed by order%"),0) as "Total Redeemed points"
from cequity.users u 
inner join cequity.profile p on p.uid=u.uid 
inner join cequity.users_roles ur on ur.uid=u.uid 
left join cequity.field_data_field_customer_first_name cfn on cfn.entity_id=u.uid 
left join cequity.field_data_field_customer_last_name cln on cln.entity_id=u.uid
where ur.rid=8 
