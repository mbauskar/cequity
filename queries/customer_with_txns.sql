select foo.* from
(
select
distinct
n.title as Store,u.uid as UID,
ifnull(ff.field_customer_first_name_value,"") "First Name",
ifnull(fl.field_customer_last_name_value,"") as "Last Name",
ifnull(u.mail,"") as "eMail ID",
ifnull(u.name,"") as "Mobile Number",
uo.order_id as "Order ID",
ifnull((select sum(ifnull(upr.amount,0)) from cequity.uc_payment_receipts upr where upr.order_id=uo.order_id and upr.comment not like "%Return amount using%"),0) as "Order Total",
uo.product_count as "Product Count",
from_unixtime(uo.created)as "Order Date",
ifnull(uo.order_status,"") as "Order Status",
ifnull(uo.payment_method,"") as "Payment Method",
ifnull((select sum(points) from userpoints_txn where entity_id=uo.order_id and status=0 and operation="add"),0) as "Points Earned",
ifnull((select sum(ifnull(amount,0)) from cequity.uc_payment_receipts where uc_payment_receipts.order_id=uo.order_id and uc_payment_receipts.method="Other" and comment like "Checkout completed from a POS using clp%" group by uc_payment_receipts.order_id),0) as "Points Redeemed",
doc.field_doc_no_value as "DOC NO",
""as "Celio Customer id"

from
uc_orders uo
inner join users u on uo.uid=u.uid
inner join profile p on u.uid=p.uid
inner join users_roles ur on p.uid=ur.uid
left join field_revision_field_customer_first_name ff on ff.entity_id=p.pid
left join field_revision_field_customer_last_name fl on fl.entity_id=p.pid
inner join field_revision_field_order_store_id os on os.entity_id=uo.order_id
inner join node n on n.nid=os.field_order_store_id_nid
inner join cequity.field_data_field_doc_no doc on doc.entity_id=uo.order_id
inner join cequity.field_data_field_acknowledge ack on ack.entity_id=uo.order_id

where date(from_unixtime(uo.created))="{report_date}"  
and doc.field_doc_no_value is not null
and n.title is not null
and ur.rid=8
and ack.field_acknowledge_value=1 )foo
