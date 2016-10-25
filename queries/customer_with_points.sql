select foo1.* from
(
select distinct foo.store as "Store",foo.uid as "UID",foo.first_name as "First Name",foo.last_name as "Last Name",foo.email as "eMail ID",foo.mobile_no as "Mobile Number",
ifnull((case when foo.last_lp<0 then 0 else foo.last_lp end  ),0) as "Last LP",
ifnull((case when foo.total_lp<0 then 0 else foo.total_lp end  ),0) as "Total LP",
ifnull((case when foo.last_sp<0 then 0 else foo.last_sp end  ),0) as "Last SP",
ifnull((case when foo.total_sp<0 then 0 else foo.total_sp end  ),0) as "Total SP"
from
(
select
distinct
n.title as "Store",u.uid as "UID",
ifnull(ff.field_customer_first_name_value,"") as first_name,
ifnull(fl.field_customer_last_name_value,"") as last_name,
ifnull(u.mail,"") as email,
ifnull(u.name,"") as mobile_no,
(select (coalesce(points,0)) from userpoints_txn where  status=0 and uid=u.uid and 
date(from_unixtime(time_stamp))<=date(from_unixtime(txn.time_stamp)) order by txn_id desc limit 1) as last_lp,
o.order_id,
(select sum(coalesce(points,0)) from cequity.userpoints_total ut where ut.uid=u.uid ) as total_lp,
(select coalesce(social_points,0) from sp_storage_txn where uid=u.uid and 
date(from_unixtime(last_updated))<=date(from_unixtime(txn.time_stamp)) order by txn_id desc limit 1) as last_sp,

(select sum(coalesce(spt.max_spoints,0)) from cequity.sp_storage_total spt where spt.uid=u.uid ) as total_sp 
from
userpoints_txn txn
inner join users u on txn.uid=u.uid
inner join profile p on u.uid=p.uid
inner join users_roles ur on p.uid=ur.uid
left join field_revision_field_customer_first_name ff on ff.entity_id=p.pid
left join field_revision_field_customer_last_name fl on fl.entity_id=p.pid
inner join uc_orders o on o.order_id=txn.entity_id
inner join field_revision_field_order_store_id os on os.entity_id=o.order_id
inner join node n on n.nid=os.field_order_store_id_nid
inner join cequity.field_data_field_doc_no doc on doc.entity_id=o.order_id
inner join cequity.field_data_field_acknowledge ack on ack.entity_id=o.order_id
where  date(from_unixtime(o.created))="{report_date}"
and doc.field_doc_no_value is not null
and n.title is not null
and ur.rid=8
and ack.field_acknowledge_value=1 )foo)foo1
