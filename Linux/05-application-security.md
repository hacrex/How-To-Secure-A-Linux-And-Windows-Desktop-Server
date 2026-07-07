# 05 - Linux Application Security

Application security focuses on protecting the software running on your server from vulnerabilities and attacks. This section covers general best practices for securing applications and specific hardening steps for common web servers like Nginx.

## 1. General Application Security Best Practices

Regardless of the application, several fundamental practices can enhance its security:

*   **Least Privilege**: Run applications and services with the minimum necessary privileges. Avoid running applications as `root` unless absolutely essential.
*   **Regular Updates**: Keep all applications, libraries, and frameworks up-to-date to patch known vulnerabilities. Enable automatic updates where appropriate.
*   **Input Validation**: Implement strict input validation to prevent common attacks like SQL injection, cross-site scripting (XSS), and command injection.
*   **Secure Configuration**: Always configure applications with security in mind. Disable unnecessary features, change default credentials, and restrict access.
*   **Logging and Monitoring**: Configure applications to log security-relevant events and integrate these logs with your centralized logging system for monitoring and alerting.
*   **Error Handling**: Implement robust error handling that avoids revealing sensitive information (e.g., stack traces, database errors) to users.
*   **Security Headers**: Implement HTTP security headers to protect web applications from various client-side attacks.
*   **Containerization**: For modern deployments, consider containerizing applications (e.g., Docker, Kubernetes) to provide isolation and consistent environments. Ensure container images are hardened and regularly scanned for vulnerabilities.

## 2. Securing Nginx Web Server

Nginx is a popular web server often used as a reverse proxy or load balancer. Hardening Nginx involves configuring it to minimize information disclosure and protect against common web attacks.

### 2.1. Disable Server Tokens

By default, Nginx reveals its version number in HTTP response headers, which can be used by attackers to identify known vulnerabilities. Disable this information disclosure.

Add the following line to your `nginx.conf` (typically in the `http` or `server` block):

```nginx
server_tokens off;
```

### 2.2. Implement HTTP Security Headers

HTTP security headers provide an additional layer of defense against various web-based attacks. These should be added to your Nginx configuration, usually within the `http`, `server`, or `location` blocks.

*   **Content Security Policy (CSP)**: Prevents a wide range of attacks, including XSS and data injection, by specifying which dynamic resources are allowed to load.
    ```nginx
    add_header Content-Security-Policy 
"'default-src 'self'; object-src 'none'; base-uri 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; media-src 'self'; frame-ancestors 'self'; form-action 'self';";
    ```

*   **X-Frame-Options**: Prevents clickjacking attacks by controlling whether a browser can render a page in a `<frame>`, `<iframe>`, `<embed>`, or `<object>`.
    ```nginx
    add_header X-Frame-Options SAMEORIGIN always;
    ```

*   **X-XSS-Protection**: Enables the browser's built-in XSS filter. While modern browsers have robust CSP implementations, this header provides backward compatibility.
    ```nginx
    add_header X-Xss-Protection "1; mode=block" always;
    ```

*   **Referrer-Policy**: Controls how much referrer information (the origin of the request) is sent with requests.
    ```nginx
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    ```

*   **Permissions-Policy (formerly Feature-Policy)**: Allows or disallows the use of browser features (e.g., camera, microphone, geolocation) in the current document and any embedded iframes.
    ```nginx
    add_header Permissions-Policy "geolocation=(), midi=(), sync-xhr=(), microphone=(), camera=(), magnetometer=(), gyroscope=(), fullscreen=(self), payment=()";
    ```

*   **X-Content-Type-Options**: Prevents browsers from MIME-sniffing a response away from the declared content-type. This can prevent XSS attacks.
    ```nginx
    add_header X-Content-Type-Options nosniff always;
    ```

### 2.3. Enable TLS/SSL and HSTS

Encrypting traffic with TLS/SSL is fundamental for web security. HTTP Strict Transport Security (HSTS) ensures that browsers only connect to your server using HTTPS.

1.  **Obtain an SSL Certificate**: Use Let's Encrypt with Certbot for free, automated certificates.
2.  **Configure Nginx for HTTPS**:
    ```nginx
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name your_domain.com;

        ssl_certificate /etc/letsencrypt/live/your_domain.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your_domain.com/privkey.pem;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 1h;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
        ssl_stapling on;
        ssl_stapling_verify on;
        resolver 8.8.8.8 8.8.4.4 valid=300s;
        resolver_timeout 5s;

        # Enable HSTS
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

        # ... other server configurations ...
    }

    # Redirect HTTP to HTTPS
    server {
        listen 80;
        listen [::]:80;
        server_name your_domain.com;
        return 301 https://$host$request_uri;
    }
    ```

### 2.4. Limit Request Body Size

To prevent certain types of denial-of-service (DoS) attacks or large file uploads that could consume excessive resources, limit the maximum allowed size of the client request body.

```nginx
client_max_body_size 10M; # e.g., 10 megabytes
```

### 2.5. Limit Concurrent Connections

To prevent a single client from opening too many connections, which could lead to resource exhaustion, use `limit_conn` and `limit_req` directives.

```nginx
# In http block
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;

# In server or location block
limit_conn conn_limit_per_ip 10;
limit_req zone=req_limit_per_ip burst=10 nodelay;
```

### 2.6. Protect Against DDoS Attacks

Nginx can be configured to mitigate certain types of DDoS attacks by limiting request rates, connection rates, and using various access controls.

*   **Rate Limiting**: As shown above with `limit_req_zone` and `limit_conn_zone`.
*   **Block Malicious User Agents**: Use `map` directive to block known malicious user agents.
*   **GeoIP Blocking**: Block traffic from specific countries if your service is not intended for global access.

### 2.7. Secure Nginx Configuration Files and Permissions

Ensure that Nginx configuration files and web root directories have appropriate permissions to prevent unauthorized access or modification.

*   Nginx configuration files (e.g., `/etc/nginx/nginx.conf`, `/etc/nginx/sites-available/*`) should typically be owned by `root` and have read-only permissions for others.
*   Web root directories should be owned by the Nginx user (e.g., `www-data` or `nginx`) and have appropriate permissions to allow Nginx to read/write necessary files, but not allow arbitrary execution.

After any changes to Nginx configuration, always test the configuration and reload/restart Nginx:

```bash
sudo nginx -t
sudo systemctl reload nginx
```
