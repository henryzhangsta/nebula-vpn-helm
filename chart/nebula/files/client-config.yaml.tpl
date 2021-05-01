pki:
  ca: /etc/nebula/ca.crt
  cert: /etc/nebula/node.crt
  key: /etc/nebula/node.key

{{- if .Values.staticHostMap }}
static_host_map:
{{ toYaml .Values.staticHostMap | indent 2 }}
{{- end }}

lighthouse:
  am_lighthouse: false
    #serve_dns: false
    #dns:
    # The DNS host defines the IP to bind the dns listener to. This also allows binding to the nebula node IP.
    #host: 0.0.0.0
  #port: 53

  interval: 60
{{- if .Values.staticHostMap }}
  hosts:
{{- range (keys .Values.staticHostMap) }}
    - "{{ . }}"
{{- end }}
{{- end }}

  #remote_allow_list:
    # Example to block IPs from this subnet from being used for remote IPs.
    #"172.16.0.0/12": false

    # A more complicated example, allow public IPs but only private IPs from a specific subnet
    #"0.0.0.0/0": true
    #"10.0.0.0/8": false
    #"10.42.42.0/24": true

  #local_allow_list:
    #interfaces:
      #tun0: false
      #'docker.*': false
      #"10.0.0.0/8": true

listen:
  # To listen on both any ipv4 and ipv6 use "[::]"
  host: 0.0.0.0
  port: 0

  #batch: 64

  #read_buffer: 10485760
  #write_buffer: 10485760

# EXPERIMENTAL: This option is currently only supported on linux and may
# change in future minor releases.
#
# Routines is the number of thread pairs to run that consume from the tun and UDP queues.
# Currently, this defaults to 1 which means we have 1 tun queue reader and 1
# UDP queue reader. Setting this above one will set IFF_MULTI_QUEUE on the tun
# device and SO_REUSEPORT on the UDP socket to allow multiple queues.
#routines: 1

punchy:
  punch: true
    # respond means that a node you are trying to reach will connect back out to you if your hole punching fails
    # this is extremely useful if one node is behind a difficult nat, such as a symmetric NAT
    # Default is false
    #respond: true

    # delays a punch response for misbehaving NATs, default is 1 second, respond must be true to take effect
    #delay: 1s

#cipher: chachapoly
#local_range: "172.16.0.0/24"

#sshd:
  #enabled: true
  #listen: 127.0.0.1:2222
  #host_key: ./ssh_host_ed25519_key
  #authorized_users:
  #- user: steeeeve
    #keys:
      #- "ssh public key string"

tun:
  disabled: false
  dev: nebula1
  drop_local_broadcast: false
  drop_multicast: false
  tx_queue: 500
  mtu: 1300
  routes:
  #- mtu: 8800
  #  route: 10.0.0.0/16
{{- if .Values.tun.unsafeRoutes }}
  unsafe_routes:
{{ toYaml .Values.tun.unsafeRoutes | indent 4 }}
{{- end }}

logging:
  level: info
  format: text
  #disable_timestamp: true
  #timestamp_format: "2006-01-02T15:04:05.000Z07:00"

#stats:
  #type: graphite
  #prefix: nebula
  #protocol: tcp
  #host: 127.0.0.1:9999
  #interval: 10s

  #type: prometheus
  #listen: 127.0.0.1:8080
  #path: /metrics
  #namespace: prometheusns
  #subsystem: nebula
  #interval: 10s

  # enables counter metrics for meta packets
  #   e.g.: `messages.tx.handshake`
  # NOTE: `message.{tx,rx}.recv_error` is always emitted
  #message_metrics: false

  # enables detailed counter metrics for lighthouse packets
  #   e.g.: `lighthouse.rx.HostQuery`
  #lighthouse_metrics: false

# Handshake Manger Settings
#handshakes:
  #try_interval: 100ms
  #retries: 20
  #trigger_buffer: 64

firewall:
  conntrack:
    tcp_timeout: 12m
    udp_timeout: 3m
    default_timeout: 10m
    max_connections: 100000

  outbound:
{{ toYaml .Values.firewall.outbound | indent 4 }}

  inbound:
    # Allow icmp between any nebula hosts
    - port: any
      proto: icmp
      host: any
{{ toYaml .Values.firewall.inbound | indent 4 }}
