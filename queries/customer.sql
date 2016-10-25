select
distinct n.title as "Store",u.uid as "UID",
ifnull(ff.field_customer_first_name_value,"") as "First Name",
ifnull(fl.field_customer_last_name_value,"") as "Last Name",
ifnull(u.mail,"") as "eMail ID",
ifnull(u.name,"") as "Mobile Number",
"" as "Address",
"" as "Sex",
"" as "DOB",
"" as "DOA",
from_unixtime(u.created)as "Registered Date",
"" as "Registration Source",
"" as "Voucher",
"" as "Referred By"
from
users u
inner join profile p on u.uid=p.uid
inner join users_roles ur on p.uid=ur.uid
left join field_revision_field_customer_first_name ff on ff.entity_id=p.pid
left join field_revision_field_customer_last_name fl on fl.entity_id=p.pid
left  join uc_orders o on o.order_id in (select min(order_id) from uc_orders where uid=u.uid)
left join field_revision_field_order_store_id os on os.entity_id=o.order_id
left join node n on n.nid=os.field_order_store_id_nid
where ur.rid=8 
and date(from_unixtime(u.created))="{report_date}"
