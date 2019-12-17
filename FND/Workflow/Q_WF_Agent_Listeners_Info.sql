SELECT t.component_name,
       p.owner,
       p.queue_table,
       t.correlation_id
  FROM applsys.fnd_svc_components t,
       applsys.wf_agents          o,
       dba_queues                 p
 WHERE t.inbound_agent_name || t.outbound_agent_name = o.name
   AND p.owner || '.' || p.name = o.queue_name
   AND t.component_type LIKE 'WF_%AGENT%'; 
