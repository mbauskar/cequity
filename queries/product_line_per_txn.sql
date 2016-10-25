select * from(
select
distinct
doc.field_doc_no_value as "DOC NO",
coalesce(pc.field_order_cashier_value,"") as Cashier,
n.title as Store,
uo.order_id as "Order id",
ifnull(up.model,"") as Product,
ifnull(td.name,"") as Family,
ifnull(ps.field_product_style_value,"") as Style,
u.UID,
uop.Qty
from
uc_orders uo
left join users u on uo.uid=u.uid
left join profile p on u.uid=p.uid
left join users_roles ur on p.uid=ur.uid
left join field_revision_field_customer_first_name ff on ff.entity_id=p.pid
left join field_revision_field_customer_last_name fl on fl.entity_id=p.pid
left join field_revision_field_order_store_id os on os.entity_id=uo.order_id
left join node n on n.nid=os.field_order_store_id_nid
left join field_data_field_doc_no doc on uo.order_id=doc.entity_id
left join uc_order_products uop on uop.order_id=uo.order_id
left join uc_products up on uop.nid=up.nid
left join field_data_field_order_cashier pc on pc.entity_id=uo.order_id
left join field_revision_field_product_style ps on ps.entity_id=up.nid
left join field_revision_taxonomy_catalog tc on tc.entity_id=uop.nid
left join taxonomy_term_data td on td.tid=tc.taxonomy_catalog_tid
inner join cequity.field_data_field_acknowledge ack on ack.entity_id=uo.order_id
where date(from_unixtime(uo.created))="{report_date}" 
and doc.field_doc_no_value is not null
and n.title is not null
and ack.field_acknowledge_value=1
order by from_unixtime(uo.created) desc
)foo
