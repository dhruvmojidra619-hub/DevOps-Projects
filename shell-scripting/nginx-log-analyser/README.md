# Nginx Log Analyser

A shell script that analyses nginx access logs and outputs the top 5 IP addresses, requested paths, response status codes, and user agents. It processes raw log files using standard Unix tools (`awk`, `sort`, `uniq`) and presents a ranked summary of each metric.

## Requirements

- Linux
- Bash
- An nginx access log file

## Instructions to Run

**1. Download the log file**
```bash
wget -O nginx-access.log https://gist.githubusercontent.com/nilbuild/e66c3b9ea89a1a030d3b739eeeef22d0/raw/77fb3ac837a73c4f0206e78a236d885590b7ae35/nginx-access.log
```

**2. Make the script executable**
```bash
chmod +x nginx_analyser.sh
```

**3. Run it**
```bash
./nginx_analyser.sh
```

## Usage

```bash
# Uses default nginx-access.log
./nginx_analyser.sh

# Specify a custom log file
./nginx_analyser.sh /path/to/custom.log
```

## Sample Output

```
=== Top 5 IP Addresses ===
178.128.94.113 - 1087 requests
142.93.136.176 - 1087 requests
138.68.248.85 - 1087 requests
159.89.185.30 - 1086 requests
86.134.118.70 - 277 requests

=== Top 5 Requested Paths ===
/v1-health - 4560 requests
/ - 270 requests
/v1-me - 232 requests
/v1-list-workspaces - 127 requests
/v1-list-timezone-teams - 75 requests

=== Top 5 Response Status Codes ===
200 - 5740 requests
404 - 937 requests
304 - 621 requests
400 - 192 requests
166 - 30 requests

=== Top 5 User Agents ===
DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com) - 4347 requests
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 513 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36 - 332 requests
Custom-AsyncHttpClient - 294 requests
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36 - 282 requests
```

## Project URL

https://roadmap.sh/projects/nginx-log-analyser
