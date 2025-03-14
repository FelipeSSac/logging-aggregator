config:
  service: |
    [SERVICE]
        Flush        1
        Log_Level    ${log_level}
        Daemon       off
        Parsers_File parsers.conf

  inputs: |
    [INPUT]
        Name        tail
        Path        /var/log/containers/*.log
        Parser      docker
        Tag         kube.*
        Refresh_Interval 5
        
  customParsers: |
    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%LZ

  outputs: |
    [OUTPUT]
        Name            es
        Match           *
        Host            ${es_host}
        Port            ${es_port}
        Logstash_Format On
        Logstash_Prefix ${logstash_prefix}
        Replace_Dots    On
        Retry_Limit     False
        tls             ${tls_enabled ? "On" : "Off"}
        tls.verify      ${tls_enabled ? "On" : "Off"}
        HTTP_User       $${FLUENT_ELASTICSEARCH_USER}
        HTTP_Passwd     $${FLUENT_ELASTICSEARCH_PASSWORD}
        Suppress_Type_Name On