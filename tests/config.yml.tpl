phantom:
  address: $APP_HOST:$APP_PORT
  ssl: false                 # Enable ssl. Default: False
  ammofile: ammo.txt
  # ammo_type: uri
  load_profile:
    load_type: rps
    schedule: $APP_SCHEDULE
  header_http: "1.1"
  phantom_http_line: 8K     # First line length. Default: 1K
  phantom_http_field: 16K   # Header size. Default: 8K
  # headers:
  #   - "[Host: myapp.dev]"
  #   - "[Authorization: bearer xxxxxx]"

# Autostop load testing
autostop:    
  autostop: 
    - http(5xx,25%,1s)  

console:
  enabled: true

telegraf:
  enabled: false

influx:
  enabled: true
  address: influx
  database: metrics
  tank_tag: 'mytank'